require 'fitting/report/action'

module Fitting
  module Report
    class Actions
      class Empty < RuntimeError; end
      class NotFound < RuntimeError
        attr_reader :log

        def initialize(msg, log)
          @log = log
          super(msg)
        end
      end

      def cover!

      end

      def initialize(actions)
        @actions = []
        actions.to_a.map do |action|
          @actions.push(Fitting::Report::Action.new(action))
        end
      end

      def find!(log)
        raise Empty if @actions.empty?
        @actions.map do |action|
          if log.method == action.method && action.path_match(log.path)
            return action
          end
        end
        raise NotFound.new("method: #{log.method}, host: #{log.host}, path: #{log.path}", log)
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
