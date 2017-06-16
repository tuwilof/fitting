require 'fitting/route/coverage'
require 'fitting/route/requests'
require 'fitting/route/responses'
require 'fitting/cover'

module Fitting
  class Route
    def initialize(all_responses, routes, strict)
      @coverage = Fitting::Route::Coverage.new(all_responses, routes, strict)
      @requests = Fitting::Route::Requests.new(@coverage)
      @responses = Fitting::Route::Responses.new(routes, @coverage)
      @cover = Fitting::Cover.new(all_responses, @coverage)
    end

    def statistics_with_conformity_lists
      congratulation = 'All responses are 100% valid! Great job!' if @coverage.not_coverage.empty?

      [
        @requests.conformity_lists,
        @requests.statistics,
        @responses.statistics,
        congratulation
      ].compact.join("\n\n")
    end

    def errors
      @coverage.not_coverage.join("\n") + "\n"
    end

    def cover_save
      @cover.save
    end
  end
end
