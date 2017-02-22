require 'json-schema'
require 'fitting/storage/documentation'

module Fitting
  class Request
    def initialize(env_request)
      @method = env_request.request_method
      @path = env_request.env['PATH_INFO']
      @body = env_request.env['action_dispatch.request.request_parameters']
      @schema = Fitting::Storage::Documentation.tomogram.find_request(method: @method, path: @path)
      @fully_validate = JSON::Validator.fully_validate(@schema['request'], @body) if @schema
      @valid = false
      @valid = true if @fully_validate == []
      self
    end

    def route
      "#{@schema['method']} #{@schema['path']}"
    end

    def real
      "#{@method} #{@path}"
    end

    def where_schema(status:)
      if @schema
        @schema.find_responses(status: status).map do |response|
          response['body']
        end
      end
    end
  end
end
