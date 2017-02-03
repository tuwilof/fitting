require 'multi_json'

module Fitting
  module Storage
    class JsonFile
      NAME = 'storage.json'.freeze

      def self.craft
        save({})
      end

      def self.save(json)
        File.open(NAME, 'w') do |file|
          file.write(MultiJson.dump(json))
        end
      end

      def self.push(key, value)
        save(tests.merge(key => value))
      rescue
      end

      def self.tests
        MultiJson.load(File.read(NAME))
      rescue
      end

      def self.load
        MultiJson.load(File.read(NAME))
      end

      def self.destroy
        File.delete(NAME)
      end
    end
  end
end
