require 'fitting/report/prefix'

module Fitting
  module Report
    class Prefixes
      def initialize(config_path)
        @prefixes = []
        YAML.safe_load(File.read(config_path))['prefixes'].map do |prefix|
          @prefixes.push(Fitting::Report::Prefix.new(prefix['name']))
        end
      end

      def is_there_a_suitable_prefix?(test_path)
        @prefixes.map do |prefix|
          return true if test_path[0..prefix.name.size - 1] == prefix.name
        end

        false
      end

      def cram_into_the_appropriate_prefix(test)
        @prefixes.map do |prefix|
          if test.path[0..prefix.name.size - 1] == prefix.name
            prefix.add_test(test)
            return
          end
        end
      end

      def to_a
        @prefixes
      end
    end
  end
end
