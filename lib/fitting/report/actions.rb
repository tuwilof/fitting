require 'fitting/report/action'

module Fitting
  module Report
    class Actions
      def initialize(actions)
        @actions = []
        actions.to_a.map do |action|
          @actions.push(Fitting::Report::Action.new(action))
        end
      end

      def to_a
        @actions
      end

      def join(tests)
        tests.to_a.map do |test|
          if there_a_suitable_action?(test)
            cram_into_the_appropriate_action(test)
            test.mark_action
          end
        end
      end

      def there_a_suitable_action?(test)
        @actions.map do |action|
          return true if test.method == action.method && action.path_match(test.path)
        end

        false
      end

      def cram_into_the_appropriate_action(test)
        @actions.map do |action|
          if test.method == action.method && action.path_match(test.path)
            action.add_test(test)
            break
          end
        end
      end

      def details(prefix)
        {
          tests_without_actions: prefix.tests.without_actions,
          actions_details: @actions.map do |a|
                             { method: a.method, path: a.path, tests_size: a.tests.size, responses: a.details }
                           end
        }
      end
    end
  end
end
