require 'yaml'

module Fitting
  module Report
    class Response
      NAME = 'report_response.yaml'

      def initialize(routes)
        @json = routes.to_hash
      end

      def save
        File.open(NAME, 'w') do |file|
          file.write(YAML.dump(@json))
        end
      end
    end
  end
end
