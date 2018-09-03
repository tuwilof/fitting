module Fitting
  class Statistics
    class CoverError
      def initialize(measurement)
        @measurement = measurement
      end

      def to_s
        [
          ''
        ].compact.join("\n\n")
      end
    end
  end
end
