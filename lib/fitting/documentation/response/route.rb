module Fitting
  module Documentation
    module Response
      class Route
        def initialize(tomogram, coverage_responses)
          @tomogram = tomogram
          @coverage_responses = coverage_responses
        end

        def coverage
          @coverage_responses.map do |response|
            response.route if response.documented? && response.valid?
          end.compact.uniq
        end

        def not_coverage
          all - coverage
        end

        def cover_ratio
          (coverage.size.to_f / all.size.to_f * 100.0).round(2)
        end

        def all
          routes = {}
          MultiJson.load(@tomogram).map do |request|
            responses = {}
            request['responses'].map do |response|
              unless responses[response['status']]
                responses[response['status']] = 0
              end
              responses[response['status']] += 1
            end

            responses.map do |response|
              response.last.times do |index|
                route = "#{request['method']} #{request['path']} #{response.first} #{index}"
                routes[route] = nil
              end
            end
          end
          routes.keys
        end
      end
    end
  end
end
