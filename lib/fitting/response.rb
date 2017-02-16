module Fitting
  class Response
    attr_accessor :status, :body, :schemas

    class Unsuitable < RuntimeError; end
    class NotDocumented < RuntimeError; end

    def initialize(env_response, expect_request)
      @status = env_response.status
      @body = env_response.body
      @schemas = expect_request.find_responses(status: @status).map{|response|response['body']} if expect_request
      @fully_validates = set_fully_validate if @schemas
      raise Response::NotDocumented unless (@schemas && @schemas.first) || Fitting.configuration.skip_not_documented
      self
    end

    def valid!
      raise Unsuitable unless @valid
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

    def validate?
      @schemas && @schemas.first && Fitting.configuration.validation_response
    end

    def to_hash
      {
        'status' => @status,
        'body' => @body,
        'schemas' => @schemas,
        'fully_validates' => @fully_validates,
        'valid' => @valid
      }
    end
  end
end
