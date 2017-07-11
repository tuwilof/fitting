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
      records = Fitting::Records.new

      RSpec.configure do |config|
        config.before(:suite) do
          records.initialization_of_documentation(Fitting::Storage::Documentation.tomogram.to_hash)
        end

        config.after(:each, type: :controller) do
          responses.add(response)
          records.add(response)
        end

        config.after(:suite) do
          responses.statistics.save
          records.save_statistics
        end
      end
    end
  end
end
