require "csv"
require "time"
require "trading_day_jp"

module Jpx
  module Price
    class << self
      def parse(path)
        data = CSV.read(path)[1..-1].map do |row|
          next if row.empty?

          # 取引日, _, 識別コード, セッション区分, 時刻, 始値, 高値, 安値, 終値, 出来高, VWAP, 約定回数, _, 限月（i = 13）
          datetime = Time.parse(row[0] + row[4])

          # 期近のみ取得
          next unless near_term?(datetime, row[13])

          # 大引けの場合15:15になるので、15:10として扱う
          datetime -= 60 * 5 if row[4] == "1515"

          if row[3] == "003"
            prev_date = TradingDayJp.prev(datetime.to_date)
            prev_datetime = Time.new(prev_date.year, prev_date.month, prev_date.day, datetime.hour, datetime.min)

            # ナイトセッションの場合、実際に取引が行われた日時に変換する
            datetime =
              if datetime.hour >= 16
                prev_datetime
              else
                prev_datetime + 60 * 60 * 24
              end
          end

          {
            datetime: datetime
          }
        end

        data.compact
      end

      def near_term?(time, contract_month)
        date = time.to_date
        @sq_dates ||= sq_dates
        sq_date = @sq_dates.find { |sq_date| sq_date > date }
        near_contract_month = sprintf("%d%02d", sq_date.year, sq_date.month)

        contract_month == near_contract_month
      end

      # MSQ祝日は今のところない
      def sq_dates
        from = Date.new(2006, 1, 1)
        to = Date.today + 120

        (from.year..to.year).map do |year|
          [3, 6, 9, 12].map do |month|
            start = Date.new(year, month, 1)
            dates = (start..(start + 14))
            first_firday = dates.find { |date| date.wday == 5 }
            second_friday = dates.find { |date| date > first_firday && date.wday == 5 }

            second_friday
          end
        end.flatten
      end
    end
  end
end
