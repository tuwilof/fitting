require 'yaml'

module Fitting
  module Report
    class Response
      def initialize(routes)
        @json = routes.to_hash
      end

      def save
        File.open('report_response.yaml', 'w') do |file|
          file.write(YAML.dump(@json))
        end
      end
    end
  end
end
