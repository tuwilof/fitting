module Fitting
  class Records
    class Tested
      class Responses
        def initialize
          @responses = []
        end

        def find_or_add(new_response)
          @responses.push(new_response) unless added?(new_response)
        end

        def added?(new_response)
          @responses.any? do |old_response|
            responses_equal?(old_response, new_response) &&
              requests_equal?(old_response.request, new_response.request)
          end
        end

        def to_a
          @responses
        end

        private

        def responses_equal?(old_response, new_response)
          old_response.status == new_response.status &&
            old_response.body == new_response.body
        end

        def requests_equal?(old_request, new_request)
          old_request.method == new_request.method &&
            old_request.path == new_request.path &&
            old_request.body == new_request.body
        end
      end
    end
  end
end
