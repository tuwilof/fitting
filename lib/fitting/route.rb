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

    def statistics
      [@requests.statistics, @responses.statistics].join("\n\n")
    end

    def statistics_with_conformity_lists
      congratulation = "All responses are 100% valid! Great job!" if @coverage.not_coverage.empty?

      [@requests.conformity_lists, statistics, congratulation].compact.join("\n\n")
    end

    def errors
      @coverage.not_coverage.join("\n") + "\n"
    end
  end
end
