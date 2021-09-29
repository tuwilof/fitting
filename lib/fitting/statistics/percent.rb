module Fitting
  class Statistics
    class Percent
      def initialize(divider, dividend)
        @divider = divider
        @dividend = dividend
      end

      def to_f
        return 0.to_f if @divider.zero?

        (@dividend.to_f / @divider * 100.0).round(2)
      end

      def to_s
        "#{@dividend} (#{to_f}% of #{@divider})"
      end
    end
  end
end
