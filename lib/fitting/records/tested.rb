require 'fitting/records/tested/requests'
require 'fitting/records/tested/responses'

module Fitting
  class Records
    class Tested
      def initialize
        @requests = Fitting::Records::Tested::Requests.new
        @responses = Fitting::Records::Tested::Responses.new
      end
    end
  end
end
