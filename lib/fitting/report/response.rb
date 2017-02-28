require 'yaml'

module Fitting
  module Report
    class Response
      def initialize(name, routes)
        @name = name
        @json = routes.to_hash
      end

      def save
        File.open(@name, 'w') do |file|
          file.write(YAML.dump(@json))
        end
      end
    end
  end
end
