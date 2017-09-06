require 'tomograph/path'
require 'fitting/records/tested/response'

module Fitting
  class Records
    class Tested
      class Request
        attr_reader :method, :path, :body, :response

        def initialize(env_response)
          @method = env_response.request.request_method
          @path = Tomograph::Path.new(env_response.request.env['PATH_INFO'] || env_response.request.fullpath)
          @body = env_response.request.env['action_dispatch.request.request_parameters']
          @response = Fitting::Records::Tested::Response.new(env_response)
        end
      end
    end
  end
end
