require 'fitting/report/prefix'

module Fitting
  module Report
    class Prefixes
      def initialize(config_path)
        @prefixes = []
        YAML.safe_load(File.read(config_path))['prefixes'].map do |prefix|
          @prefixes.push(
            Fitting::Report::Prefix.new(
              name: prefix['name'],
              openapi2_json_path: prefix['openapi2_json_path'],
              openapi3_yaml_path: prefix['openapi3_yaml_path'],
              drafter_yaml_path: prefix['drafter_yaml_path'],
              tomogram_json_path: prefix['tomogram_json_path'],
              crafter_yaml_path: prefix['crafter_yaml_path'],
              skip: prefix['skip']
            )
          )
        end
      end

      def there_a_suitable_prefix?(test_path)
        @prefixes.map do |prefix|
          return true if prefix.name.nil?
          return true if prefix.name == ''
          return true if test_path[0..prefix.name.size - 1] == prefix.name
        end

        false
      end

      def cram_into_the_appropriate_prefix(test)
        @prefixes.map do |prefix|
          if prefix.name.nil? || prefix.name == '' || test.path[0..prefix.name.size - 1] == prefix.name
            prefix.add_test(test)
            break
          end
        end
      end

      def join(tests)
        tests.to_a.map do |test|
          if there_a_suitable_prefix?(test.path)
            cram_into_the_appropriate_prefix(test)
            test.mark_prefix
          end
        end
      end

      def to_a
        @prefixes
      end
    end
  end
end
