require 'fitting/version'
require 'fitting/configuration'
require 'fitting/documentation/response/route'
require 'fitting/storage/responses'
require 'fitting/storage/documentation'
require 'fitting/report/response'
require 'fitting/matchers/response_matcher'

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
        origin_run_specs(example_groups)
        return if Fitting::Storage::Responses.nil?

        routes = Fitting::Documentation::Response::Route.new(
          Fitting::Storage::Documentation.hash,
          Fitting::Storage::Responses.all
        )
        puts "Coverage documentation API (responses) by RSpec tests: #{routes.cover_ratio}%"
        Fitting::Report::Response.new(routes).save
      end
    end
  end
end
