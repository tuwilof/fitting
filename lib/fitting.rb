require 'fitting/version'
require 'fitting/configuration'
require 'fitting/storage/documentation'
require 'fitting/matchers/response_matcher'
require 'fitting/documentation'
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
      records = Fitting::Records.new

      RSpec.configure do |config|
        config.after(:each, type: :controller) do
          records.add(response)
        end

        config.after(:suite) do
          records.save_statistics
        end
      end
    end
  end
end
