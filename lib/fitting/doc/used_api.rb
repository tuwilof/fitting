require 'fitting/doc/api/action'

module Fitting
  class Doc
    class UsedAPI
      class Skip < RuntimeError; end
      class NotFound < RuntimeError; end

      attr_accessor :host, :path, :actions

      def initialize(path, host)
        @path = path
        @host = host
        tomogram = Tomograph::Tomogram.new(tomogram_json_path: path)

        @actions = []
        tomogram.to_a.map do |action|
          @actions.push(Fitting::Doc::Api::Action.new(action, host, ''))
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

      def self.all(yaml)
        yaml['UsedAPIs'].map do |host|
          new(host['path'], host['host'])
        end
      end

      def prefix
        ''
      end

      def cover!
      end
    end
  end
end
