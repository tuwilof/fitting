require 'fitting/report/action'

module Fitting
  module Report
    class Actions
      class Empty < RuntimeError; end

      def initialize(actions)
        @actions = []
        actions.to_a.map do |action|
          @actions.push(Fitting::Report::Action.new(action))
        end
      end

      def find!(test)
        raise Empty if @actions.empty?
        @actions.map do |action|
          if test.method == action.method && action.path_match(test.path)
            return action
          end
        end
      end

      def to_a
        @actions
      end

      def push(actions)
        @actions += actions.to_a
      end
    end
  end
end
