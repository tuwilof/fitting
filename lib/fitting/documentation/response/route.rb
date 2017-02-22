require 'multi_json'

module Fitting
  module Documentation
    module Response
      class Route
        def initialize(tomogram, coverage_responses)
          @tomogram = tomogram
          @coverage_responses = coverage_responses
        end

        def coverage
          @coverage ||= @coverage_responses.map do |response|
            response.route if response.documented? && response.valid?
          end.compact.uniq
        end

        def not_coverage
          @not_coverage ||= all - coverage
        end

        def all
          @all ||= MultiJson.load(@tomogram).inject([]) do |routes, request|
            request['responses'].inject({}) do |responses, response|
              responses[response['status']] ||= 0
              responses[response['status']] += 1
              responses
            end.map do |status, indexes|
              indexes.times do |index|
                route = "#{request['method']} #{request['path']} #{status} #{index}"
                routes.push(route)
              end
            end
            routes
          end.uniq
        end

        def cover_ratio
          @cover_ratio ||= (coverage.size.to_f / all.size.to_f * 100.0).round(2)
        end
      end
    end
  end
end
