module Fitting
  module Report
    class Combinations
      def initialize(combinations)
        @combinations = combinations
      end

      def to_a
        @combinations
      end

      def size
        @combinations.size
      end

      def size_with_tests
        @combinations.count { |c| c.tests.size != 0 }
      end

      def join(tests)
        tests.to_a.map do |test|
          if is_there_a_suitable_combination?(test)
            cram_into_the_appropriate_combinations(test)
            test.mark_combination
          end
        end
      end

      def is_there_a_suitable_combination?(test)
        return false if @combinations.nil?
        @combinations.map do |combination|
          return true if JSON::Validator.fully_validate(combination.json_schema, test.body) == []
        end

        false
      end

      def cram_into_the_appropriate_combinations(test)
        @combinations.map do |combination|
          if JSON::Validator.fully_validate(combination.json_schema, test.body) == []
            combination.add_test(test)
          end
        end
      end
    end
  end
end
