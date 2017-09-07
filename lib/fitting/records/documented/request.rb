require 'fitting/records/documented/response'

module Fitting
  class Records
    class Documented
      class Request
        attr_reader :method, :path, :json_schema, :responses, :white

        def initialize(tomogram_request, white_list)
          @method = tomogram_request['method']
          @path = tomogram_request['path']
          @json_schema = tomogram_request['json_schema']
          @white = false
          @responses = []
          joind_white_list(white_list.to_a)
        end

        def grouping(tomogram_responses)
          tomogram_responses.group_by do |tomogram_response|
            tomogram_response['status']
          end.inject({}) do |res, group|
            res.merge({group[0] => group[1].map { |subgroup| subgroup['body'] }})
          end
        end

        def add_responses(tomogram_responses)
          grouping_responses = grouping(tomogram_responses)
          grouping_responses.map do |status, json_schemas|
            @responses.push(
              Fitting::Records::Documented::Response.new(status, json_schemas)
            )
          end
        end

        private

        def joind_white_list(white_list)
          if white_list == nil
            @white = true
            return
          end

          return if white_list[@path.to_s] == nil

          @white = true if white_list[@path.to_s] == [] || white_list[@path.to_s].include?(@method)
        end
      end
    end
  end
end
