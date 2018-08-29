require 'fitting/configuration/yaml'
require 'fitting/configuration/legacy'
require 'yaml'

module Fitting
  class Configuration
    class << self
      def craft
        if one_yaml?
          one_yaml
        elsif more_than_one_yaml?
          more_than_one_yaml
        else
          legacy
        end
      end

      def one_yaml?
        File.file?('.fitting.yml')
      end

      def more_than_one_yaml?
        !Dir['fitting/*.yml'].empty?
      end

      def one_yaml
        yaml = YAML.safe_load(File.read('.fitting.yml'))
        Fitting::Configuration::Yaml.new(yaml)
      end

      def more_than_one_yaml
        files.map do |file|
          yaml = YAML.safe_load(File.read(file))
          Fitting::Configuration::Yaml.new(yaml, file[8..-5])
        end
      end

      def legacy
        Fitting::Configuration::Legacy.new
      end

      def files
        Dir['fitting/*.yml']
      end
    end
  end
end
