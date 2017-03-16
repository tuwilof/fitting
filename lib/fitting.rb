require 'fitting/version'
require 'fitting/configuration'
require 'fitting/storage/documentation'
require 'fitting/storage/skip'
require 'fitting/matchers/response_matcher'
require 'rspec/core'
require 'fitting/statistics'
require 'fitting/documentation'

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

        puts Fitting::Statistics.new(
          Fitting::Documentation.new(Fitting.configuration.tomogram, Fitting.configuration.white_list),
          Fitting::Storage::Responses.all)

        if Fitting.configuration.necessary_fully_implementation_of_responses &&
          returned_exit_code == 0 &&
          response.not_coverage?
          return ERROR_EXIT_CODE
        end
        returned_exit_code
      end
    end
  end
end
