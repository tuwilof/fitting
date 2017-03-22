require 'fitting/request'
require 'fitting/response/fully_validates'

module Fitting
  class Response
    def initialize(env_response, tomogram)
      @request = Fitting::Request.new(env_response.request, tomogram)
      @status = env_response.status
      @body = env_response.body
      @schemas = @request.schemas_of_possible_responses(status: @status)
    end

    def fully_validates
      @fully_validates ||= Fitting::Response::FullyValidates.craft(@schemas, @body, false)
    end

    def strict_fully_validates
      @strict_fully_validates ||= Fitting::Response::FullyValidates.craft(@schemas, @body, true)
    end

    def documented?
      @schemas && @schemas.present?
    end

    def route
      "#{@request.route} #{@status} #{index}"
    end

    def strict_route
      "#{@request.route} #{@status} #{strict_index}"
    end

    def real_request_with_status
      "#{@request.real_method_with_path} #{@status}"
    end

    def got
      @body
    end

    def expected
      @schemas.inject([]) do |res, schema|
        res.push("#{schema}")
      end.join("\n\n")
    end

    private

    def index
      @schemas.size.times do |i|
        if fully_validates[i] == []
          return i
        end
      end
    end

    def strict_index
      @schemas.size.times do |i|
        if strict_fully_validates[i] == []
          return i
        end
      end
    end
  end
end
