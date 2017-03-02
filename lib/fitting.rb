require 'fitting/version'
require 'fitting/configuration'
require 'fitting/documentation/response/route'
require 'fitting/documentation/request/route'
require 'fitting/storage/responses'
require 'fitting/storage/documentation'
require 'fitting/storage/skip'
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

        return if Fitting::Storage::Skip.get

        response_routes = Fitting::Documentation::Response::Route.new(
          Fitting::Storage::Documentation.hash,
          Fitting::Storage::Responses.all
        )
        request_routes = Fitting::Documentation::Request::Route.new(response_routes)

        valid_count = response_routes.coverage.size
        valid_percentage = response_routes.cover_ratio
        total_count = response_routes.all.size
        invalid_count = response_routes.not_coverage.size
        invalid_percentage = 100.0 - response_routes.cover_ratio
        puts "API responses conforming to the blueprint: #{valid_count} (#{valid_percentage}% of #{total_count})."
        puts "API responses with validation errors or untested: #{invalid_count} (#{invalid_percentage}% of #{total_count})."

        full_count = request_routes.to_hash['full cover'].size
        part_count = request_routes.to_hash['partial cover'].size
        no_count = request_routes.to_hash['no cover'].size
        total_count = full_count + part_count + no_count
        full_percentage = (full_count.to_f / total_count.to_f * 100.0).round(2)
        part_percentage = (part_count.to_f / total_count.to_f * 100.0).round(2)
        no_percentage = (no_count.to_f / total_count.to_f * 100.0).round(2)
        puts "API requests with fully implemented responses: #{full_count} (#{full_percentage}% of #{total_count})."
        puts "API requests with partially implemented responses: #{part_count} (#{part_percentage}% of #{total_count})."
        puts "API requests with no implemented responses: #{no_count} (#{no_percentage}% of #{total_count})."
        puts
        puts "Conforming requests: \n#{request_routes.fully_implemented.join("\n")} \n\n"
        puts "Partially conforming requests: \n#{request_routes.partially_implemented.join("\n")} \n\n"
        puts "Non-conforming requests: \n#{request_routes.no_implemented.join("\n")} \n\n"

        exit if response_routes.not_coverage.present? && Fitting.configuration.crash_not_implemented_response
      end
    end
  end
end
