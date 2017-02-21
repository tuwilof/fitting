require 'fitting/storage/responses'

module Fitting
  module Report
    class Response
      def initialize
        @json = {
          'coverage' => Fitting::Storage::Responses.routes,
          'not coverage' => Fitting::Documentation.routes - Fitting::Storage::Responses.routes
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
