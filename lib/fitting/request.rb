module Fitting
  class Request
    attr_accessor :path, :method, :body, :schema

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

    def to_hash
      {
        'method' => @method,
        'path' => @path,
        'body' => @body,
        'schema' => @schema
      }
    end
  end
end
