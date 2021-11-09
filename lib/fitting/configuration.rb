require 'fitting/configuration/yaml'
require 'yaml'

module Fitting
  class Configuration
    def self.craft
      yaml = YAML.safe_load(File.read('.fitting.yml'))
      Fitting::Configuration::Yaml.new(yaml)
    end
  end
end
