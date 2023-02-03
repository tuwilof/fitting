module Fitting
  class Skip
    class API
      attr_accessor :type, :host, :prefix, :path

      def initialize(type, host, prefix)
        @type = type
        @host = host
        @prefix = prefix
      end

      def self.all(apis)
        return [] unless apis
        apis.map do |api|
          next if api['method'] || api['path']
          new('provided', api['host'], api['prefix'])
        end.compact
      end

      def self.find(apis, log)
        apis.find do |api|
          if log.host == api.host
            api.prefix.nil? || api.prefix == '' || log.path[0..api.prefix.size - 1] == api.prefix
          end
        end
      end
    end
  end
end
