require 'fitting/version'
require 'fitting/configuration'
require 'fitting/documentation/response/routes'
require 'fitting/storage/documentation'
require 'fitting/storage/skip'
require 'fitting/matchers/response_matcher'
require 'rspec/core'
require 'fitting/documentation/request/route'
require 'fitting/statistics'

ERROR_EXIT_CODE = 1

module Fitting
  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end

module RSpec
  module Core
    # Provides the main entry point to run a suite of RSpec examples.
    class Runner
      alias origin_run_specs run_specs

      def run_specs(example_groups)
        returned_exit_code = origin_run_specs(example_groups)

        return returned_exit_code if Fitting::Storage::Skip.get

        response_routes = Fitting::Documentation::Response::Routes.new(
          Fitting::Storage::Documentation.hash,
          Fitting.configuration.white_list
        )
        response_route_white = Fitting::Documentation::Response::Route.new(
          Fitting::Storage::Responses.all,
          response_routes.white
        )

        puts Fitting::Statistics.new(response_routes, response_route_white)

        if Fitting.configuration.necessary_fully_implementation_of_responses &&
          returned_exit_code == 0 &&
          response_route_white.not_coverage.present?
          return ERROR_EXIT_CODE
        end
        returned_exit_code
      end
    end
  end
end
