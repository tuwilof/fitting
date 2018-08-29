require 'fitting/statistics'
require 'fitting/tests'
require 'fitting/records/tested/request'

module Fitting
  module Storage
    class Responses
      def initialize
        @tested_requests = []
      end

      def add(env_response, test_title = '')
        @tested_requests.push(Fitting::Records::Tested::Request.new(env_response, test_title))
      end

      def statistics
        Fitting::Statistics.new(@tested_requests)
      end

      def tests
        Fitting::Tests.new(@tested_requests)
      end
    end
  end
end
