require 'yaml'

module Fitting
  module Storage
    class YamlFile
      NAME = 'storage.yaml'.freeze

      def self.craft
        save("---\n")
      end

      def self.save(json)
        File.open(NAME, 'w') do |file|
          file.write(json)
        end
      end

      def self.push(key, value)
        save(tests + YAML.dump(key => value)[4..-1])
      rescue
      end

      def self.tests
        File.read(NAME)
      rescue
      end

      def self.load
        YAML.load(File.read(NAME))
      end

      def self.destroy
        File.delete(NAME)
      end
    end
  end
end
