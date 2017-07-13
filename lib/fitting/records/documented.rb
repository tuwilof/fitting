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

      def join(tested)
        @requests.join(tested.requests)
      end

      def joind_white_list(white_list)
        @requests.joind_white_list(white_list)
      end
    end
  end
end
