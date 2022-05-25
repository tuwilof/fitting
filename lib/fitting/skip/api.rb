module Fitting
  class Skip
    class API
      attr_accessor :type, :host, :prefix, :path

      def initialize(type, host, prefix)
        @type = type
        @host = host
        @prefix = prefix
      end

      def self.all(yaml)
        yaml['SkipProvidedAPIs'].map do |api|
          new('provided', 'www.example.com', api['prefix'])
        end + yaml['SkipUsedAPIs'].map do |api|
          new( 'used', api['host'], '')
        end
      end

      def self.find(apis, log)
        apis.find do |api|
          if api.type == 'provided' && log.type == 'incoming'
            if log.host == api.host
              api.prefix['name'].nil? || log.path[0..prefix['name'].size - 1] == api.prefix['name']
            end
          elsif api.type == 'used' && log.type == 'outgoing'
            if log.host == api.host
              api.prefix['name'].nil? || log.path[0..prefix['name'].size - 1] == api.prefix['name']
            end
          end
        end
      end
    end
  end
end
