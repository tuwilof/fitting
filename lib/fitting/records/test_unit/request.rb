require 'json-schema'

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
          @test_path ||= @tested_request.title
        end

        def test_file_path
          @test_file_path ||= @tested_request.group
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
          end.flatten.compact
        end

        def response_documented?
          @response_documented ||= documented_responses.present?
        end

        def response_json_schemas
          @response_json_schemas ||= documented_responses.inject([]) do |res, documented_response|
            res.push(documented_response["json_schemas"])
          end.flatten
        end

        def response_json_schemas?
          @response_json_schemas_present ||= response_json_schemas.present?
        end

        def valid_json_schemas
          @valid_json_schemas ||= response_json_schemas.inject([]) do |res, json_schema|
            next res unless JSON::Validator.validate(json_schema, response.body)
            res.push(json_schema)
          end.flatten
        end

        def invalid_json_schemas
          @invalid_json_schemas ||= response_json_schemas.inject([]) do |res, json_schema|
            next res if JSON::Validator.validate(json_schema, response.body)
            res.push(
              {
                json_schema: json_schema,
                fully_validate: JSON::Validator.fully_validate(json_schema, response.body)
              }
            )
          end.flatten
        end

        def valid_json_schemas?
          @valid_json_schemas_present ||= valid_json_schemas.present?
        end
      end
    end
  end
end
