require 'fitting/request'
require 'json-schema'

module Fitting
  class Response
    def initialize(env_response, tomogram)
      @request = Request.new(env_response.request, tomogram)
      @status = env_response.status
      @body = env_response.body
      @schemas = @request.schemas_of_possible_responses(status: @status)
      @fully_validates = set_fully_validate if @schemas
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
      @schemas && @schemas.present?
    end

    def valid?
      @valid == true
    end

    def route
      "#{@request.route} #{@status} #{index}"
    end

    def real_request_with_status
      "#{@request.real_method_with_path} #{@status}"
    end

    def got
      @body
    end

    def diff
      @fully_validates.inject("") do |res, fully_validate|
        res + "#{fully_validate}\n"
      end
    end

    def expected
      @schemas.inject("") do |res, schema|
        res + "#{schema}\n"
      end
    end

    private

    def index
      @schemas.size.times do |i|
        if @fully_validates[i] == []
          return i
        end
      end
    end
  end
end
