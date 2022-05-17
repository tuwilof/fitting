require 'fitting/doc/api/action'
require 'fitting/report/actions'

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

        @actions = Fitting::Report::Actions.new([])
        @actions.push(Fitting::Report::Actions.new(tomogram))
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
