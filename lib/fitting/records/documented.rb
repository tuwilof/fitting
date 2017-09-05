require 'fitting/records/documented/requests'
require 'fitting/records/documented/responses'

module Fitting
  class Records
    class Documented
      attr_reader :requests, :responses

      def initialize(tomogram, white_list)
        @responses = Fitting::Records::Documented::Responses.new
        @requests = Fitting::Records::Documented::Requests.new(tomogram, @responses, white_list)
      end

      def join(tested)
        @requests.join(tested.requests)
      end
    end
  end
end
