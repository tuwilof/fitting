module Fitting
  class Doc
    class UsedAPI
      class Skip < RuntimeError; end

      class NotFound < RuntimeError; end

      attr_accessor :host, :prefix, :path, :type

      def initialize(path, host)
        @path = path
        @host = host
      end

      def self.all(yaml)
        yaml['UsedAPIs'].map do |host|
          new(host['path'], host['host'])
        end
      end

      def self.find!(docs, log)
        new
      end

      def actions
      end

      def cover!
      end
    end
  end
end
