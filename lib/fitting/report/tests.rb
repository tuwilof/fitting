require 'fitting/report/test'

module Fitting
  module Report
    class Tests
      attr_reader :tests

      def initialize(tests)
        @tests = tests
      end

      def self.new_from_config
        tests = []
        Dir["#{Fitting.configuration.rspec_json_path}/*.json"].each do |file|
          JSON.parse(File.read(file)).map do |test|
            tests.push(Fitting::Report::Test.new(test))
          end
        end
        tests.sort { |a, b| b.path <=> a.path }
        new(tests)
      end

      def self.new_from_outgoing_config
        tests = []
        Dir["#{Fitting.configuration.webmock_json_path}/*.json"].each do |file|
          JSON.parse(File.read(file)).map do |test|
            tests.push(Fitting::Report::Test.new(test))
          end
        end
        tests.sort { |a, b| b.path <=> a.path }
        new(tests)
      end

      def without_prefixes
        tests.each_with_object([]) do |test, result|
          result.push(test.path) unless test.there_a_prefix?
        end
      end

      def without_actions
        tests.each_with_object([]) do |test, result|
          result.push("#{test.method} #{test.path}") unless test.there_an_actions?
        end
      end

      def without_responses
        tests.each_with_object([]) do |test, result|
          result.push(test.id) unless test.there_an_responses?
        end
      end

      def without_combinations
        tests.each_with_object([]) do |test, result|
          result.push(test.path) unless test.there_an_combinations?
        end
      end

      def push(test)
        tests.push(test)
      end

      def size
        tests.size
      end

      def to_a
        tests
      end

      def to_h
        return @hash if @hash

        @hash = tests.inject({}) do |res, test|
          res.merge!(test.id => test.to_h)
        end
      end
    end
  end
end
