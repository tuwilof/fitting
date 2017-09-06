module Fitting
  class Records
    class Tested
      class Response
        def initialize(env_response)
          @env_response = env_response
        end

        def status
          @status ||= @env_response.status
        end

        def body
          @body ||= @env_response.body
        end
      end
    end
  end
end
