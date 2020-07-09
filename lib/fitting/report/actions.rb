require 'fitting/report/action'

module Fitting
  module Report
    class Actions
      def initialize(prefix, tomogram_json_path)
        actions = Tomograph::Tomogram.new(
            prefix: prefix,
            tomogram_json_path: tomogram_json_path
        )
        @actions = []
        actions.to_a.map do |action|
          @actions.push(Fitting::Report::Action.new(action))
        end
      end

      def join(tests)
        tests.to_a.map do |test|
          if is_there_a_suitable_action?(test)
            cram_into_the_appropriate_action(test)
            test.mark_action
          end
        end
      end

      def is_there_a_suitable_action?(test)
        @actions.map do |action|
          return true if test.method == action.method && action.path_match(test.path)
        end

        false
      end

      def cram_into_the_appropriate_action(test)
        @actions.map do |action|
          if test.method == action.method && action.path_match(test.path)
            action.add_test(test)
            return
          end
        end
      end

      def details(prefix)
        {
            tests_without_actions: prefix.tests.without_actions,
            actions_details: @actions.map { |a| {method: a.method, path: a.path, tests_size: a.tests.size} }
        }
      end
    end
  end
end
