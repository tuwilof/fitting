require 'fitting/records/documented/requests'
require 'fitting/records/documented/responses'

module Fitting
  class Records
    class Documented
      def initialize(tomogram)
        @requests = Fitting::Records::Documented::Requests.new(tomogram)
        @responses = Fitting::Records::Documented::Responses.new(tomogram)
      end
    end
  end
end
