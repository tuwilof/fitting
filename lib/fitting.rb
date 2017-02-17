require 'fitting/version'
require 'fitting/documentation'
require 'fitting/configuration'

require 'yaml'
require 'fitting/report/response'
require 'fitting/storage/tests'
require 'fitting/storage/trying_tests'

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

        tests = Fitting::Storage::TryingTests.all

        report = Fitting::Report::Response.new(tests).to_hash
        File.open('report_response.yaml', 'w') do |file|
          file.write(YAML.dump(report))
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.after(:each, :type => :controller) do
    Fitting::Storage::Tests.push(self)
  end
end
