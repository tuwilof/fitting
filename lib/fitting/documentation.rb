require 'json-schema'

module Fitting
  class Documentation
    class << self
      def try_on(date, env_request, env_response)
        request = Request.new(env_request, tomogram)
        request.valid! if request.validate?
        response = Response.new(env_response, request.schema)
        Fitting::JsonFile.push(
          location(date),
          'request' => MultiJson.dump(request.to_hash),
          'response' => MultiJson.dump(response.to_hash)
        )
        response.valid! if response.validate?
      end

      private

      def tomogram
        @tomogram ||= TomogramRouting::Tomogram.craft(Fitting.configuration.tomogram)
      end

      def location(date)
        date.inspect.to_s.split('(').last.split(')').first
      end
    end
  end
end
