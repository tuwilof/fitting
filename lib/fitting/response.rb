require 'fitting/request'
require 'fitting/response/fully_validates'
require 'json'
require 'multi_json'

module Fitting
  class Response
    def initialize(env_response, tomogram)
      @request = Fitting::Request.new(env_response.request, tomogram)
      @status = env_response.status
      @body = env_response.body
      @schemas = @request.schemas_of_possible_responses(status: @status)
    end

    def within_prefix?(prefix)
      @request.within_prefix?(prefix)
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
      index.map do |i|
        "#{@request.route} #{@status} #{i}"
      end
    end

    def strict_route
      strict_index.map do |i|
        "#{@request.route} #{@status} #{i}"
      end
    end

    def real_request_with_status
      "#{@request.real_method_with_path} #{@status}"
    end

    def got
      JSON.pretty_generate(MultiJson.load(@body))
    end

    def expected
      @expected ||= @schemas.inject([]) do |res, schema|
        res.push(JSON.pretty_generate(schema).to_s)
      end.join("\n\n")
    end

    private

    def index
      return @index_res if @index_res
      @index_res = []
      @schemas.size.times do |i|
        @index_res.push(i) if fully_validates[i] == []
      end
      @index_res
    end

    def strict_index
      return @strict_index_res if @strict_index_res
      @strict_index_res = []
      @schemas.size.times do |i|
        @strict_index_res.push(i) if strict_fully_validates[i] == []
      end
      @strict_index_res
    end
  end
end
