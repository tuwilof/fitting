require 'fitting/report/actions'

module Fitting
  module Report
    class Prefix
      def initialize(name, tomogram_json_path, skip = false)
        @name = name
        @tomogram_json_path = tomogram_json_path
        @tests = Fitting::Report::Tests.new([])
        @skip = skip
        unless skip
          @actions = Fitting::Report::Actions.new(name, tomogram_json_path)
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
        @actions
      end

      def details
        if @skip
          {
              name: @name,
              tests_size: @tests.size,
              actions: {tests_without_actions: [], actions_details: []}
          }
        else
          {
              name: @name,
              tests_size: @tests.size,
              actions: @actions.details(self)
          }
        end
      end

      def add_test(test)
        @tests.push(test)
      end
    end
  end
end
