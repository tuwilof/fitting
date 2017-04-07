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

    def add_to_stats(response)
      Fitting::Storage::Responses.push(
        Fitting::Response.new(
          response,
          Fitting::Storage::Documentation.tomogram))
    end

    def generate_stats
      statistics = Fitting::Statistics.new(
        Fitting::Documentation.new(Fitting::Storage::Documentation.tomogram, Fitting.configuration.white_list),
        Fitting::Storage::Responses.all,
        Fitting.configuration.strict
      )
      if Fitting.configuration.create_report_with_name
        statistics.save(Fitting.configuration.create_report_with_name)
      end
    end
  end
end
