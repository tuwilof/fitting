module Fitting
  class Records
    class Tested
      class Request
        attr_reader :method, :path, :body

        def initialize(env_request)
          @method = env_request.request_method
          @path = env_request.env['PATH_INFO'] || env_request.fullpath
          @body = env_request.env['action_dispatch.request.request_parameters']
        end
      end
    end
  end
end
