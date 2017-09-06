require 'fitting/records/tested/requests'
require 'fitting/records/tested/request'
require 'fitting/records/tested/response'

module Fitting
  class Records
    class Tested
      attr_reader :requests

      def initialize
        @requests = Fitting::Records::Tested::Requests.new
      end

      def add(env_response)
        request = Fitting::Records::Tested::Request.new(env_response.request)
        response = Fitting::Records::Tested::Response.new(env_response, request)
        request.add_response(response)
        @requests.find_or_add(request)
      end
    end
  end
end
