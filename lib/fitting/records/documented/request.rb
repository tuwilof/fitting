module Fitting
  class Records
    class Documented
      class Request
        def initialize(tomogram_request, white_list)
          @tomogram_request = tomogram_request
          @white_list = white_list
        end

        def method
          @method ||= @tomogram_request['method']
        end

        def path
          @path ||= @tomogram_request['path']
        end

        def json_schema
          @json_schema ||= @tomogram_request['json_schema']
        end

        def responses
          @responses ||= @tomogram_request['responses'].group_by do |tomogram_response|
            tomogram_response['status']
          end.map do |group|
            {
              'status' => group[0],
              'json_schemas' => group[1].map { |subgroup| subgroup['body'] }
            }
          end
        end

        def white
          @white ||= if @white_list == nil
                       true
                     elsif @white_list[path.to_s] == nil
                       false
                     elsif @white_list[path.to_s] == []
                       true
                     elsif @white_list[path.to_s].include?(method)
                       true
                     else
                       false
          end
        end
      end
    end
  end
end
