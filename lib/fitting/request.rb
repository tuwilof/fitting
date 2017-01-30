module Fitting
  class Request
    attr_accessor :path, :method, :body, :schema

    class Unsuitable < RuntimeError; end
    class NotDocumented < RuntimeError; end

    def initialize(env_request, tomogram)
      @method = env_request.request_method
      @path = env_request.env['PATH_INFO']
      @body = env_request.env['action_dispatch.request.request_parameters']
      @schema = tomogram.find_request(method: @method, path: @path)
      raise NotDocumented unless @schema || Fitting.configuration.skip_not_documented
      self
    end

    def valid!
      res = JSON::Validator.fully_validate(@schema['request'], @body)
      raise Unsuitable unless res.empty?
    end

    def validate?
      @schema && Fitting.configuration.validation_requests
    end

    def to_hash
      {
        'method' => @method,
        'path' => @path,
        'body' => @body,
        'schemas' => @schemas
      }
    end
  end
end
