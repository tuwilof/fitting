require 'fitting/statistics/list'

module Fitting
  class Statistics
    class Lists
      def initialize(measurement)
        @measurement = measurement
      end

      def to_s
        [
          coverage_fully_stat,
          coverage_partially_stat,
          coverage_non_stat
        ].compact.join("\n\n")
      end

      def coverage_fully_stat
        if @measurement.coverage_fully == []
          nil
        else
          [
            'Fully conforming requests:',
            Fitting::Statistics::List.new(@measurement.coverage_fully, @measurement.max_response_path).to_s
          ].join("\n")
        end
      end

      def coverage_partially_stat
        if @measurement.coverage_partially == []
          nil
        else
          [
            'Partially conforming requests:',
            Fitting::Statistics::List.new(@measurement.coverage_partially, @measurement.max_response_path).to_s
          ].join("\n")
        end
      end

      def coverage_non_stat
        if @measurement.coverage_non == []
          nil
        else
          [
            'Non-conforming requests:',
            Fitting::Statistics::List.new(@measurement.coverage_non, @measurement.max_response_path).to_s
          ].join("\n")
        end
      end
    end
  end
end
