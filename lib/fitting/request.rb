require 'json-schema'

module Fitting
  class Request
    def initialize(env_request, tomogram)
      @method = env_request.request_method
      @path = env_request.env['PATH_INFO']
      @body = env_request.env['action_dispatch.request.request_parameters']
      @schema = tomogram.find_request(method: @method, path: @path)
      @fully_validate = JSON::Validator.fully_validate(@schema['request'], @body) if @schema
      @valid = false
      @valid = true if @fully_validate == []
      self
    end

    def route
      "#{@schema['method']}\t#{@schema['path']}"
    end

    def real_method_with_path
      "#{@method}\t#{@path}"
    end

    def schemas_of_possible_responses(status:)
      if @schema
        @schema.find_responses(status: status).map do |response|
          response['body']
        end
      end
    end
  end
end
