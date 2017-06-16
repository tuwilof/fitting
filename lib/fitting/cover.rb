module Fitting
  class Cover
    def initialize(all_responses, coverage)
      @all_responses = all_responses
      @coverage = coverage
      @list = {}
    end

    def to_hash
      @all_responses.map do |response|
        @list[response.route] = nil unless @list.has_key?(response.route)
      end
      @list
    end

    def save
      @coverage.coverage
    end
  end
end
