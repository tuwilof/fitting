require 'json-schema'

module Fitting
  class Request
    def initialize(env_request, tomogram)
      @method = env_request.request_method
      @path = env_request.env['PATH_INFO'] || env_request.fullpath
      @body = env_request.env['action_dispatch.request.request_parameters']
      @schema = tomogram.find_request(method: @method, path: @path)
    end

    def route
      "#{@schema.method}\t#{@schema.path}"
    end

    def real_method_with_path
      "#{@method}\t#{@path}"
    end

    def schemas_of_possible_responses(status:)
      return nil unless @schema

      @schema.find_responses(status: status).map do |response|
        response['body']
      end
    end

    def within_prefix?(prefix)
      @path.start_with?(prefix)
    end

    def ignored?(ignore_list)
      ignore_list.any? do |regexp|
        regexp.match(@path)
      end
    end
  end
end
