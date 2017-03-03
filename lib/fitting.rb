require 'fitting/version'
require 'fitting/configuration'
require 'fitting/documentation/response/route'
require 'fitting/documentation/request/route'
require 'fitting/storage/responses'
require 'fitting/storage/documentation'
require 'fitting/storage/skip'
require 'fitting/matchers/response_matcher'

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

        response_routes = Fitting::Documentation::Response::Route.new(
          Fitting::Storage::Documentation.hash,
          Fitting::Storage::Responses.all
        )
        request_routes = Fitting::Documentation::Request::Route.new(response_routes)

        request_routes.conformity_lists
        request_routes.statistics
        response_routes.statistics

        if response_routes.not_coverage.present? &&
          Fitting.configuration.crash_not_implemented_response &&
          returned_exit_code == 0
          return ERROR_EXIT_CODE
        end
        returned_exit_code
      end
    end
  end
end
