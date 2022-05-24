module Fitting
  class Skip
    class API
      attr_accessor :type, :host, :prefix, :path

      def initialize(type, host, prefix)
        @type = type
        @host = host
        @prefix = prefix
      end
    end
  end
end
