require 'fitting/cover/response'

module Fitting
  class Cover
    def initialize(all_responses, coverage)
      @all_responses = all_responses
      @coverage = coverage
      @list = {}
    end

    def to_hash
      @all_responses.each_with_object({}) do |response, res|
        next res unless response.documented?
        if res.key?(response.route)
          res[response.route].update(response)
        else
          res[response.route] = Fitting::Cover::Response.new(response)
        end
      end.map do |key, value|
        @list[key] = value.to_hash
      end
      @list
    end

    def save
      to_hash
    end
  end
end
