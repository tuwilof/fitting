require 'tomograph/path'

module Fitting
  class Records
    class Tested
      class Request
        attr_reader :method, :path, :body, :documented_request

        def initialize(env_request)
          @method = env_request.request_method
          @path = Tomograph::Path.new(env_request.env['PATH_INFO'] || env_request.fullpath)
          @body = env_request.env['action_dispatch.request.request_parameters']
        end

        def join(documented_request)
          @documented_request = documented_request
        end
      end
    end
  end
end
