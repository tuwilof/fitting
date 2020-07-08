require 'fitting/report/test'

module Fitting
  module Report
    class Tests
      def initialize(tests_path)
        @tests = []
        Dir[tests_path].each do |file|
          JSON.load(File.read(file)).map do |test|
            @tests.push(Fitting::Report::Test.new(test))
          end
        end
        @tests.sort { |a, b| b.path <=> a.path }
      end

      def without_prefixes
        @tests.inject([]) do |result, test|
          result.push(test.path) unless test.is_there_a_prefix?
          result
        end
      end

      def to_a
        @tests
      end
    end
  end
end
