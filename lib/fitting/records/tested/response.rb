module Fitting
  class Records
    class Tested
      class Response
        attr_reader :status, :body

        def initialize(env_response)
          @status = env_response.status
          @body = env_response.body
        end
      end
    end
  end
end
