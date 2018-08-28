require 'fitting/records/spherical/response'

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

        def to_spherical
          Fitting::Records::Spherical::Response.new(
            status: status,
            body: body
          )
        end
      end
    end
  end
end
