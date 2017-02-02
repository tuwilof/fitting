require 'json-schema'

module Fitting
  class Documentation
    class << self
      def try_on(date, env_request, env_response)
        request = Request.new(env_request, tomogram)
        request.valid! if request.validate?
        response = Response.new(env_response, request.schema)
        response.valid! if response.validate?
        add_storage(location(date), request, response)
      end

      private

      def add_storage(location, request, response)
        Fitting::Storage::YamlFile.push(
          location,
          'request' => MultiJson.dump(request.to_hash),
          'response' => MultiJson.dump(response.to_hash)
        )
      end

      def tomogram
        @tomogram ||= TomogramRouting::Tomogram.craft(Fitting.configuration.tomogram)
      end

      def location(date)
        date.inspect.to_s.split('(').last.split(')').first
      end
    end
  end
end
