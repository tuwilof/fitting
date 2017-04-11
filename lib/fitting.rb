require 'fitting/version'
require 'fitting/configuration'
require 'fitting/storage/documentation'
require 'fitting/storage/skip'
require 'fitting/matchers/response_matcher'
require 'fitting/statistics'
require 'fitting/documentation'
require 'fitting/storage/responses'

module Fitting
  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def add_to_stats(responses, response)
      responses.push(
        Fitting::Response.new(
          response,
          Fitting::Storage::Documentation.tomogram))
    end

    def generate_stats(responses)
      statistics = Fitting::Statistics.new(
        Fitting::Documentation.new(Fitting::Storage::Documentation.tomogram, Fitting.configuration.white_list),
        responses.all,
        Fitting.configuration.strict
      )
      statistics.save
    end

    def start
      responses = Fitting::Storage::Responses.new

      RSpec.configure do |config|
        config.after(:each, type: :controller) do
          Fitting.add_to_stats(responses, response)
        end

        config.after(:suite) do
          Fitting.generate_stats(responses)
        end
      end
    end
  end
end
