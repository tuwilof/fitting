require 'fitting/records/tested/body'

module Fitting
  class Records
    class Tested
      class Response
        attr_reader :status, :body

        def initialize(env_response)
          @status = env_response.status
          @body = Fitting::Records::Tested::Body.new(env_response.body)
        end
      end
    end
  end
end
