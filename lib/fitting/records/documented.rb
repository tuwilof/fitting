require 'fitting/records/documented/requests'

module Fitting
  class Records
    class Documented
      attr_reader :requests

      def initialize(tomogram, white_list)
        @requests = Fitting::Records::Documented::Requests.new(tomogram, white_list)
      end
    end
  end
end
