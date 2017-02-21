require 'tomogram_routing'

module Fitting
  class Documentation
    class << self
      def tomogram
        @tomogram ||= TomogramRouting::Tomogram.craft(Fitting.configuration.tomogram)
      end

      def routes
        routes = {}
        MultiJson.load(Fitting.configuration.tomogram).map do |request|
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
