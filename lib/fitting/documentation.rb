require 'tomogram_routing'
require 'json-schema'
require 'fitting/storage/yaml_file'
require 'fitting/request'
require 'fitting/response'
require 'fitting/matchers/response_matcher'

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

      def response(env_request, env_response)
        request = Request.new(env_request, tomogram)
        request.valid! if request.validate?
        response = Response.new(env_response, request.schema)
        response.to_hash
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
        name = date.inspect.to_s
        if name.split('(').size > 1
          name.split('(').last.split(')').first[2..-1]
        else
          name.split(' ')[3][2..-3]
        end
      end
    end
  end
end
