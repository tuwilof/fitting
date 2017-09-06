require 'fitting/records/tested/request'

module Fitting
  class Records
    class Tested
      attr_reader :requests

      def initialize
        @requests = []
      end

      def add(env_response)
        @requests.push(Fitting::Records::Tested::Request.new(env_response))
      end
    end
  end
end
