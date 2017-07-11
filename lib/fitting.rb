require 'fitting/version'
require 'fitting/configuration'
require 'fitting/storage/documentation'
require 'fitting/matchers/response_matcher'
require 'fitting/statistics'
require 'fitting/documentation'
require 'fitting/storage/responses'
require 'fitting/records'

module Fitting
  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def statistics
      responses = Fitting::Storage::Responses.new
      records = Fitting::Records.new(Fitting::Storage::Documentation.tomogram)

      RSpec.configure do |config|
        config.after(:each, type: :controller) do
          responses.add(response)
          records.add(response, response.request)
        end

        config.after(:suite) do
          responses.statistics.save
          records.save_statistics
        end
      end
    end
  end
end
