require 'multi_json'

module Fitting
  module Documentation
    module Response
      class Route
        def initialize(tomogram, coverage_responses, white_list)
          @tomogram = tomogram
          @coverage_responses = coverage_responses
          @white_list = white_list
        end

        def coverage
          @coverage ||= white - (white - full_coverage)
        end

        def not_coverage
          @not_coverage ||= white - coverage
        end

        def all
          @all ||= MultiJson.load(@tomogram).inject([]) do |routes, request|
            request['responses'].inject({}) do |responses, response|
              responses[response['status']] ||= 0
              responses[response['status']] += 1
              responses
            end.map do |status, indexes|
              indexes.times do |index|
                route = "#{request['method']}\t#{request['path']} #{status} #{index}"
                routes.push(route)
              end
            end
            routes
          end.uniq
        end

        def white
          if @white_list
            all.select do |response|
              data = response.split(' ')
              @white_list && data[1] && @white_list[data[1]] && @white_list[data[1]].include?(data[0])
            end
          else
            all
          end
        end

        def cover_ratio
          @cover_ratio ||= (coverage.size.to_f / white.size.to_f * 100.0).round(2)
        end

        def to_hash
          {
            'coverage' => coverage,
            'not coverage' => not_coverage
          }
        end

        def statistics
          valid_count = coverage.size
          valid_percentage = cover_ratio
          total_count = white.size
          invalid_count = not_coverage.size
          invalid_percentage = 100.0 - cover_ratio
          puts "API responses conforming to the blueprint: #{valid_count} (#{valid_percentage}% of #{total_count})."
          puts "API responses with validation errors or untested: #{invalid_count} (#{invalid_percentage}% of #{total_count})."
          puts
        end

        private

        def full_coverage
          @coverage_responses.map do |response|
            response.route if response.documented? && response.valid?
          end.compact.uniq
        end
      end
    end
  end
end
