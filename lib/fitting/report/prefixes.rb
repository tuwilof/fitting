require 'fitting/report/prefix'

module Fitting
  module Report
    class Prefixes
      def initialize(configuration_prefixes)
        @prefixes = []

        configuration_prefixes.map do |prefix|
          @prefixes.push(
            Fitting::Report::Prefix.new(
              schema_paths: prefix['schema_paths'],
              type: prefix['type'],
              name: prefix['name'],
              skip: prefix['skip'],
              only: prefix['only']
            )
          )
        end
      end

      def to_a
        @prefixes
      end

      def find!(test)
        @prefixes.map do |prefix|
          puts test.path
          puts test.host
          puts test.method
          puts test.status
          puts test.body
          puts prefix.name
          if test.path[0..prefix.name.size - 1] == prefix.name
            return prefix
          end
        end
      end
    end
  end
end
