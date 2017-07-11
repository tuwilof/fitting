require 'fitting/records/documented/request'

module Fitting
  class Records
    class Documented
      class Requests
        def initialize(tomogram, responses)
          @requests = tomogram.inject([]) do |requests, tomogram_request|
            request = Fitting::Records::Documented::Request.new(tomogram_request)
            request.add_responses(tomogram_request['responses'], responses)
            requests.push(request)
          end
        end

        def to_a
          @requests
        end
      end
    end
  end
end
