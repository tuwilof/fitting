require 'fitting/records/tested/requests'
require 'fitting/records/tested/responses'
require 'fitting/records/tested/request'
require 'fitting/records/tested/response'

module Fitting
  class Records
    class Tested
      attr_reader :requests, :responses

      def initialize
        @requests = Fitting::Records::Tested::Requests.new
        @responses = Fitting::Records::Tested::Responses.new
      end

      def add(env_response)
        request = Fitting::Records::Tested::Request.new(env_response.request)
        response = Fitting::Records::Tested::Response.new(env_response, request)
        @requests.find_or_add(request)
        @responses.find_or_add(response)
      end
    end
  end
end
