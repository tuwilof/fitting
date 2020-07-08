module Fitting
  module Report
    class Prefix
      def initialize(name, tomogram_json_path, skip = false)
        @name = name
        @tomogram_json_path = tomogram_json_path
        @tests = []
        @skip = skip
        unless skip
          @tomogram = Tomograph::Tomogram.new(
              prefix: name,
              tomogram_json_path: tomogram_json_path
          )
        end
      end

      def name
        @name
      end

      def tests
        @tests
      end

      def skip?
        @skip
      end

      def actions
        @tomogram.to_a
      end

      def add_test(test)
        @tests.push(test)
      end
    end
  end
end
