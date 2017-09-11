require 'fitting/records/unit/response'

module Fitting
  class Records
    class Unit
      class Request
        def initialize(documented_request, tested_requests)
          @documented_request = documented_request
          @tested_requests = tested_requests
        end

        def path
          @path ||= @documented_request.path
        end

        def method
          @method ||= @documented_request.method
        end

        def responses
          @responses ||= @documented_request.responses.to_a.inject([]) do |res, documented_response|
            res.push(Fitting::Records::Unit::Response.new(documented_response, tested_responses))
          end
        end

        def tested_responses
          @tested_responses ||= @tested_requests.inject([]) do |res, tested_request|
            next res unless @documented_request.method == tested_request.method &&
                            @documented_request.path.match(tested_request.path.to_s)
            res.push(tested_request.response)
          end
        end
      end
    end
  end
end
