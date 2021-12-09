require 'fitting/records/tested/request'

module Fitting
  module Storage
    class Responses
      attr_reader :tested_requests

      def initialize
        @tested_requests = []
      end

      def add(response, example)
        tested_requests.push(Fitting::Records::Tested::Request.new(response, example))
      end

      def tests
        Fitting::Tests.new(tested_requests)
      end
    end
  end
end
