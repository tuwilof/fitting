require 'fitting/records/unit/request'

module Fitting
  class Records
    class Unit
      def initialize(documented_requests, tested_requests)
        @documented_requests = documented_requests
        @tested_requests = tested_requests
      end

      def requests
        @requests ||= @documented_requests.to_a.inject([]) do |res, documented_request|
          res.push(Fitting::Records::Unit::Request.new(documented_request, @tested_requests))
        end
      end
    end
  end
end
