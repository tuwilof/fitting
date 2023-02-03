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
          new('provided', api['host'], api['prefix'])
        end
      end

      def self.find(apis, log)
        apis.find do |api|
          if api.type == 'provided' && log.type == 'incoming'
            if log.host == api.host
              api.prefix.nil? || api.prefix == '' || log.path[0..api.prefix.size - 1] == api.prefix
            end
          elsif api.type == 'used' && log.type == 'outgoing'
            if log.host == api.host
              api.prefix.nil? || api.prefix == '' || log.path[0..api.prefix.size - 1] == api.prefix
            end
          end
        end
      end
    end
  end
end
