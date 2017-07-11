require 'fitting/records/documented/response'

module Fitting
  class Records
    class Documented
      class Request
        attr_reader :method, :path, :json_schema, :responses

        def initialize(tomogram_request)
          @method = tomogram_request['method']
          @path = tomogram_request['path'].to_s
          @json_schema = tomogram_request['json_schema']
        end

        def add_responses(tomogram_responses, responses)
          request_responses = []
          tomogram_responses.map do |tomogram_response|
            tomogram_responses(tomogram_response, request_responses)
          end
          responses.add_responses(request_responses)
          @responses = request_responses
        end

        private

        def tomogram_responses(tomogram_response, request_responses)
          response = Fitting::Records::Documented::Response.new(tomogram_response, self)
          exist_response = request_responses.find do |old_response|
            old_response.status == response.status
          end
          if exist_response
            exist_response.add_json_schema(tomogram_response)
          else
            response.add_json_schema(tomogram_response)
            request_responses.push(response)
          end
        end
      end
    end
  end
end
