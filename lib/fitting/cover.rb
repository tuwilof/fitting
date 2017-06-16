require 'fitting/cover/response'

module Fitting
  class Cover
    def initialize(all_responses, coverage)
      @all_responses = all_responses
      @coverage = coverage
      @list = {}
    end

    def to_hash
      @all_responses.map do |response|
        next nil unless response.documented?
        if @list.key?(response.route)
          @list[response.route].update(response)
        else
          @list[response.route] = Fitting::Cover::Response.new(response)
        end
      end
      @list
    end

    def save
      to_hash
    end
  end
end
