module Fitting
  class Records
    class Documented
      class Request
        def initialize(tomogram_request, white_list)
          @tomogram_request = tomogram_request
          @white_list = white_list
        end

        def method
          @method ||= @tomogram_request.method
        end

        def path
          @path ||= @tomogram_request.path
        end

        def responses
          @responses ||= groups.map do |group|
            {
              'status' => group[0],
              'json_schemas' => group[1].map { |subgroup| subgroup['body'] }
            }
          end
        end

        def white
          @white ||= white?
        end

        private

        def white?
          return true if @white_list == nil
          return false if @white_list[path.to_s] == nil
          return true if @white_list[path.to_s] == []
          return true if @white_list[path.to_s].include?(method)
          false
        end

        def groups
          @groups ||= @tomogram_request.responses.group_by do |tomogram_response|
            tomogram_response['status']
          end
        end
      end
    end
  end
end
