require 'fitting/storage/responses'

module Fitting
  module Report
    class Response
      def initialize(routes)
        @json = {
          'coverage' => routes.coverage,
          'not coverage' => routes.not_coverage
        }
      end

      def to_hash
        @json
      end

      def save
        File.open('report_response.yaml', 'w') do |file|
          file.write(YAML.dump(to_hash))
        end
      end
    end
  end
end
