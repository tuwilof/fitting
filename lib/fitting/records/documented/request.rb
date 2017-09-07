module Fitting
  class Records
    class Documented
      class Request
        attr_reader :white

        def initialize(tomogram_request, white_list)
          @tomogram_request = tomogram_request
          @white = false
          joind_white_list(white_list.to_a)
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

        private

        def joind_white_list(white_list)
          if white_list == nil
            @white = true
            return
          end

          return if white_list[path.to_s] == nil

          @white = true if white_list[path.to_s] == [] || white_list[path.to_s].include?(method)
        end
      end
    end
  end
end
