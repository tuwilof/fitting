require 'tomograph/path'
require 'fitting/records/tested/response'

module Fitting
  class Records
    class Tested
      class Request
        def initialize(env_response)
          @env_response = env_response
        end

        def method
          @method ||= @env_response.request.request_method
        end

        def path
          @path ||= Tomograph::Path.new(@env_response.request.env['PATH_INFO'] || @env_response.request.fullpath)
        end

        def body
          @body ||= @env_response.request.env['action_dispatch.request.request_parameters']
        end

        def response
          @response ||= Fitting::Records::Tested::Response.new(@env_response)
        end
      end
    end
  end
end
