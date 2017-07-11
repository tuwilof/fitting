module Fitting
  class Records
    class Documented
      class Responses
        def initialize
          @responses = []
        end

        def add(response)
          @responses.push(response)
        end

        def add_responses(responses)
          @responses += responses
        end

        def to_a
          @responses
        end
      end
    end
  end
end
