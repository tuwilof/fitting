require 'fitting/version'
require 'fitting/configuration'
require 'fitting/matchers/response_matcher'
require 'fitting/documentation'
require 'fitting/storage/responses'

module Fitting
  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.craft
    end

    def statistics
      responses = Fitting::Storage::Responses.new

      RSpec.configure do |config|
        config.after(:each, type: :controller) do
          responses.add(response)
        end

        config.after(:suite) do
          responses.statistics.save
        end
      end
    end
  end
end
