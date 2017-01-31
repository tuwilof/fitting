require 'yaml'

module Fitting
  class YamlFile
    NAME = 'storage.yaml'.freeze

    def self.craft
      save({})
    end

    def self.save(json)
      File.open(NAME, 'w') do |file|
        file.write(YAML.dump(json))
      end
    end

    def self.push(key, value)
      save(tests.merge(key => value))
    rescue
    end

    def self.tests
      YAML.load(File.read(NAME))
    rescue
    end

    def self.destroy
      File.delete(NAME)
    end
  end
end
