module Fitting
  class Records
    class Documented
      class Request
        def initialize(tomogram_request)
          @tomogram_request = tomogram_request
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

        private

        def groups
          @groups ||= @tomogram_request.responses.group_by do |tomogram_response|
            tomogram_response['status']
          end
        end
      end
    end
  end
end
