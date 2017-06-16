module Fitting
  class Cover
    def initialize(all_responses, coverage)
      @all_responses = all_responses
      @coverage = coverage
    end

    def save
      @coverage.coverage
    end
  end
end
