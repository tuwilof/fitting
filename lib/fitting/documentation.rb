require 'tomogram_routing'
require 'json-schema'
require 'fitting/request'
require 'fitting/response'
require 'fitting/matchers/response_matcher'

module Fitting
  class Documentation
    class << self
      def try_on(response)
        request = Request.new(response.request, tomogram)
        response = Response.new(response, request.schema)
        [request.to_hash, response.to_hash]
      end

      private

      def tomogram
        @tomogram ||= TomogramRouting::Tomogram.craft(Fitting.configuration.tomogram)
      end
    end
  end
end
