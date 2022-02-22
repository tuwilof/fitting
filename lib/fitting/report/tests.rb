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
        File.read('log/test.log').split("\n").select{|f|f.include?('incoming request ')}.each do |test|
          tests.push(Fitting::Report::Test.new(JSON.load(test.split('incoming request ')[1])))
        end
        tests.sort { |a, b| b.path <=> a.path }
        new(tests)
      end

      def self.new_from_outgoing_config
        tests = []
        File.read('log/test.log').split("\n").select{|f|f.include?('outgoing request ')}.each do |test|
          tests.push(Fitting::Report::Test.new(JSON.load(test.split('incoming request ')[1])))
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
