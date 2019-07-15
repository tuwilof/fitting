require 'fitting/version'
require 'fitting/configuration'
require 'fitting/matchers/response_matcher'
require 'fitting/documentation'
require 'fitting/storage/responses'
require 'fitting/railtie' if defined?(Rails)

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
          responses.add(response, inspect)
        end

        config.after(:suite) do
          responses.statistics.save
        end
      end
    end

    def save_test_data
      responses = Fitting::Storage::Responses.new

      FileUtils.rm_r Dir.glob("fitting_tests/*"), :force => true

      RSpec.configure do |config|
        config.after(:each, type: :controller) do
          responses.add(response, inspect)
        end

        config.after(:suite) do
          responses.tests.save
        end
      end
    end
  end

  def self.loaded_tasks=(val)
    @loaded_tasks = val
  end

  def self.loaded_tasks
    @loaded_tasks
  end

  def self.load_tasks
    return if loaded_tasks
    self.loaded_tasks = true

    Dir[File.join(File.dirname(__FILE__), 'tasks', '**/*.rake')].each do |rake|
      load rake
    end
  end
end
