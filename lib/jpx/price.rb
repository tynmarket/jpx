require "csv"
require "time"

module Jpx
  module Price
    class << self
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
