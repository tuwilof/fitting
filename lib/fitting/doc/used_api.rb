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

        @actions = Fitting::Report::Actions.new([])
        @actions.push(Fitting::Report::Actions.new(tomogram))
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
