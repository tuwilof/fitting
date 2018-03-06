module Fitting
  class Records
    class TestUnit
      class Request
        def initialize(tested_request, all_documented_requests)
          @tested_request = tested_request
          @all_documented_requests = all_documented_requests
        end

        def method
          @method ||= @tested_request.method
        end

        def path
          @path ||= @tested_request.path
        end

        def body
          @body ||= @tested_request.body
        end

        def response
          @response ||= @tested_request.response
        end

        def test_path
          @test_path ||= @tested_request.test_path
        end

        def test_file_path
          @test_file_path ||= @tested_request.test_file_path
        end

        def documented_requests
          @documented_requests ||= @all_documented_requests.inject([]) do |res, documented_request|
            next res unless @tested_request.method == documented_request.method &&
              documented_request.path.match(@tested_request.path.to_s)
            res.push(documented_request)
          end
        end

        def documented?
          @documented ||= documented_requests.present?
        end

        def documented_responses
          @documented_responses ||= documented_requests.inject([]) do |res, documented_request|
            documented_request.responses.map do |documented_response|
              next unless documented_response["status"] == response.status.to_s
              res.push(documented_response)
            end
          end.flatten
        end

        def response_documented?
          @documented ||= documented_responses.present?
        end
      end
    end
  end
end
