module Fitting
  module Report
    class Combinations
      class Empty < RuntimeError; end
      class NotFound < RuntimeError; end

      def initialize(combinations)
        @combinations = combinations
      end

      def to_a
        @combinations
      end

      def find!(test)
        raise Empty if @combinations.empty?
        @combinations.map do |combination|
          if JSON::Validator.fully_validate(combination.json_schema, test.body) == []
            return combination
          end
        end
        raise NotFound
      end
    end
  end
end
