require "csv"
require "time"

module Jpx
  module Price
    class << self

      def sq_days
        from = Date.new(2006, 1, 1)
        to = Date.today

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
