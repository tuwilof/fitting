require 'fitting/records/documented/requests'
require 'fitting/records/documented/responses'

module Fitting
  class Records
    class Documented
      attr_reader :requests, :responses

      def initialize(tomogram)
        @responses = Fitting::Records::Documented::Responses.new
        @requests = Fitting::Records::Documented::Requests.new(tomogram, @responses)
      end
    end
  end
end
