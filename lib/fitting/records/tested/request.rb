require 'tomograph/path'

module Fitting
  class Records
    class Tested
      class Request
        attr_reader :method, :path, :body, :responses, :documented_request

        def initialize(env_request)
          @method = env_request.request_method
          @path = Tomograph::Path.new(env_request.env['PATH_INFO'] || env_request.fullpath)
          @body = env_request.env['action_dispatch.request.request_parameters']
          @responses = []
        end

        def add_response(response)
          @responses.push(response)
        end
      end
    end
  end
end
