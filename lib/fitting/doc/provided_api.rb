require 'fitting/doc/api/action'

module Fitting
  class Doc
    class ProvidedAPI
      class Skip < RuntimeError; end
      class NotFound < RuntimeError; end

      attr_accessor :prefix, :path, :actions

      def initialize(path, prefix)
        @path = path
        @prefix = prefix
        tomogram = Tomograph::Tomogram.new(prefix: @prefix, tomogram_json_path: path)

        @actions = []
        tomogram.to_a.map do |action|
          @actions.push(Fitting::Doc::Api::Action.new(action))
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
        yaml['ProvidedAPIs'].map do |host|
          new(host['path'], host['prefix'])
        end
      end

      def host
        'www.example.com'
      end

      def cover!
      end
    end
  end
end
