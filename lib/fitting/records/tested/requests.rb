module Fitting
  class Records
    class Tested
      class Requests
        def initialize
          @requests = []
        end

        def find_or_add(new_request)
          @requests.push(new_request) unless added?(new_request)
        end

        def added?(new_request)
          @requests.any? do |old_request|
            old_request.method == new_request.method &&
              old_request.path == new_request.path &&
              old_request.body == new_request.body
          end
        end

        def to_a
          @requests
        end
      end
    end
  end
end
