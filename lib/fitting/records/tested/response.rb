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

        def content_type
          @content_type ||= @response.content_type
        end

        def to_spherical
          Fitting::Records::Spherical::Response.new(
            status: status,
            body: body,
            content_type: content_type
          )
        end
      end
    end
  end
end
