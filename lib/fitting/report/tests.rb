require 'fitting/report/test'

module Fitting
  module Report
    class Tests
      def initialize(tests)
        @tests = tests
      end

      def self.new_from_config(tests_path)
        tests = []
        Dir[tests_path].each do |file|
          JSON.load(File.read(file)).map do |test|
            tests.push(Fitting::Report::Test.new(test))
          end
        end
        tests.sort { |a, b| b.path <=> a.path }
        new(tests)
      end

      def without_prefixes
        @tests.inject([]) do |result, test|
          result.push(test.path) unless test.is_there_a_prefix?
          result
        end
      end

      def without_actions
        @tests.inject([]) do |result, test|
          result.push(test.path) unless test.is_there_an_actions?
          result
        end
      end

      def without_responses
        @tests.inject([]) do |result, test|
          result.push(test.path) unless test.is_there_an_responses?
          result
        end
      end

      def without_combinations
        @tests.inject([]) do |result, test|
          result.push(test.path) unless test.is_there_an_combinations?
          result
        end
      end

      def push(test)
        @tests.push(test)
      end

      def size
        @tests.size
      end

      def to_a
        @tests
      end
    end
  end
end
