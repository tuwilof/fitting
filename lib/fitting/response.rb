module Fitting
  class Response
    attr_accessor :status, :body, :schemas

    class Unsuitable < RuntimeError; end
    class NotDocumented < RuntimeError; end

    def initialize(env_response, expect_request)
      @status = env_response.status
      @body = env_response.body
      @schemas = expect_request.find_responses(status: @status) if expect_request
      raise Response::NotDocumented unless (@schemas&.first) || Fitting.configuration.skip_not_documented
      self
    end

    def valid!
      flag = @schemas.any? do |doc_response|
        JSON::Validator.fully_validate(doc_response['body'], @body) == []
      end
      raise Unsuitable unless flag
    end

    def validate?
      @schemas&.first && Fitting.configuration.validation_response
    end

    def to_hash
      {
        'status' => @status,
        'body' => @body,
        'schemas' => @schemas
      }
    end
  end
end
