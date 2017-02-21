require 'fitting/request'
require 'json-schema'

module Fitting
  class Response
    def initialize(env_response)
      @request = Request.new(env_response.request)
      @status = env_response.status
      @body = env_response.body
      @schemas = @request.where_schema(status: @status)
      @fully_validates = set_fully_validate if @schemas
      Fitting::Storage::Responses.push(self)
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
      "#{@request.route} #{@status} #{index}"
    end

    def real
      "#{@request.real} #{@status}"
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
