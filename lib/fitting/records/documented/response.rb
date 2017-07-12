module Fitting
  class Records
    class Documented
      class Response
        attr_reader :status, :json_schemas, :tested_responses

        def initialize(tomogram_response, request)
          @status = tomogram_response['status']
          @json_schemas = []
          @request = request
          @tested_responses = []
        end

        def add_json_schema(tomogram_response)
          @json_schemas.push(tomogram_response['body'])
        end

        def join(tested_responses)
          tested_responses.map do |tested_response|
            if self.status == tested_response.status.to_s
              @tested_responses.push(tested_response)
            end
          end
        end
      end
    end
  end
end
