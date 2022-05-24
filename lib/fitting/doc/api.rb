require 'fitting/doc/api/action'

module Fitting
  class Doc
    class API
      class NotFound < RuntimeError; end

      attr_accessor :type, :host, :prefix, :path, :actions

      def initialize(type, host, prefix, path)
        @type = type
        @host = host
        @prefix = prefix
        @path = path
        @actions = Tomograph::Tomogram.new(prefix: @prefix, tomogram_json_path: path).to_a.inject([]) do |actions, action|
          actions.push(Fitting::Doc::Api::Action.new(action, host, prefix))
        end
      end

      def find!(log)
        raise Empty if @actions.empty?
        @actions.map do |action|
          if log.method == action.method && action.path_match(log.path)
            return action
          end
        end
        raise NotFound
      end
    end
  end
end
