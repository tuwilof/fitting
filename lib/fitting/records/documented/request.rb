require 'fitting/records/documented/response'

module Fitting
  class Records
    class Documented
      class Request
        attr_reader :method, :path, :json_schema, :responses, :tested_requests, :white

        def initialize(tomogram_request)
          @method = tomogram_request['method']
          @path = tomogram_request['path']
          @json_schema = tomogram_request['json_schema']
          @tested_requests = []
          @white = false
        end

        def add_responses(tomogram_responses, responses)
          request_responses = []
          tomogram_responses.map do |tomogram_response|
            tomogram_responses(tomogram_response, request_responses)
          end
          responses.add_responses(request_responses)
          @responses = request_responses
        end

        def join(tested_request)
          @tested_requests.push(tested_request)
          responses.map do |documented_response|
            documented_response.join(tested_request.responses)
          end
        end

        def joind_white_list(white_list)
          if white_list == nil
            @white = true
            return
          end

          return if white_list[@path.to_s] == nil

          @white = true if white_list[@path.to_s] == [] || white_list[@path.to_s].include?(@method)
        end

        def state
          return @state unless @state == nil

          all = 0
          cover = 0
          not_cover = 0

          @responses.map do |response|
            response.json_schemas.map do |json_schema|
              all += 1
              if json_schema.bodies == []
                not_cover += 1
              else
                cover += 1
              end
            end
          end

          if all == cover
            @state = 'fully'
          elsif all == not_cover
            @state = 'non'
          else
            @state = 'partially'
          end
          @state
        end

        def all_responses_coverage?
          return @coverga unless @coverga == nil

          @coverga = true
          responses.map do |response|
            if response.all_json_schemas_coverage?
              @coverga = false
              return @coverga
            end
          end
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
