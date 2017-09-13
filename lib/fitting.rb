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
      @configuration = if File.file?('.fitting.yml')
                         one_yaml
                       elsif !Dir['fitting/*.yml'].empty?
                         more_than_one_yaml
                       else
                         Configuration.new
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

    private

    def one_yaml
      yaml = YAML.safe_load(File.read('.fitting.yml'))
      YamlConfiguration.new(yaml)
    end

    def more_than_one_yaml
      Dir['fitting/*.yml'].map do |file|
        yaml = YAML.safe_load(File.read(file))
        YamlConfiguration.new(yaml, file[8..-5])
      end
    end
  end
end
