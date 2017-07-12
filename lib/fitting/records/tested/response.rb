module Fitting
  class Records
    class Tested
      class Response
        attr_reader :status, :body, :request, :documented_responses

        def initialize(env_response, request)
          @status = env_response.status
          @body = env_response.body
          @request = request
        end
      end
    end
  end
end
