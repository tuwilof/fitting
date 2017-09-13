require 'fitting/version'
require 'fitting/configuration'
require 'fitting/yaml_configuration'
require 'fitting/matchers/response_matcher'
require 'fitting/documentation'
require 'fitting/storage/responses'
require 'yaml'

module Fitting
  class << self
    def configure
      yield configuration
    end

    def configuration
      return @configuration if @configuration
      if File.file?('.fitting.yml')
        yaml = YAML.safe_load(File.read('.fitting.yml'))
        @configuration = YamlConfiguration.new(yaml)
      elsif !Dir['fitting/*.yml'].empty?
        @configuration = Dir['fitting/*.yml'].map do |file|
          yaml = YAML.safe_load(File.read(file))
          YamlConfiguration.new(yaml, file[8..-5])
        end
      else
        @configuration = Configuration.new
      end
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
