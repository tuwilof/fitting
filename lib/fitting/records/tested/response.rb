require 'fitting/records/spherical/response'

module Fitting
  class Records
    class Tested
      class Response
        def initialize(response)
          @response = response
        end

        def status
          @status ||= @response.status
        end

        def body
          @body ||= @response.body
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
