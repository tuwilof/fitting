require 'fitting/route/coverage'
require 'fitting/route/requests'
require 'fitting/route/responses'

module Fitting
  class Route
    def initialize(all_responses, routes, strict)
      @coverage = Fitting::Route::Coverage.new(all_responses, routes, strict)
      @requests = Fitting::Route::Requests.new(@coverage)
      @responses = Fitting::Route::Responses.new(routes, @coverage)
    end

    def not_coverage?
      @coverage.not_coverage.present?
    end

    def statistics
      [@requests.statistics, @responses.statistics].join("\n\n")
    end

    def statistics_with_conformity_lists
      [@requests.conformity_lists, statistics].join("\n\n")
    end

    def errors
      @coverage.not_coverage.join("\n") + "\n"
    end
  end
end
