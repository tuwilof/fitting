require 'fitting/request'
require 'json-schema'

module Fitting
  class Response
    attr_accessor :status, :body, :schemas, :fully_validates, :request

    def initialize(env_response, tomogram)
      @request = Request.new(env_response.request, tomogram)
      @status = env_response.status
      @body = env_response.body
      @schemas = @request.schema.find_responses(status: @status).map{|response|response['body']} if @request.schema
      @fully_validates = set_fully_validate if @schemas
      self
    end

    def set_fully_validate
      @valid = false
      fully_validates = []
      @schemas.map do |old_schema|
        fully_validate = JSON::Validator.fully_validate(old_schema, @body)
        fully_validates.push(fully_validate)
        @valid = true if fully_validate == []
      end
      fully_validates
    end

    def documented?
      @schemas.present?
    end

    def valid?
      @valid == true
    end

    def route
      key_request = "#{request.schema['method']} #{request.schema['path']}"
      key_response = "#{key_request} #{status}"
      "#{key_response} #{index}"
    end

    private

    def index
      schemas.size.times do |i|
        if fully_validates[i] == []
          return i
        end
      end
    end
  end
end
