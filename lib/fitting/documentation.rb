require 'tomogram_routing'
require 'json-schema'
require 'fitting/response'
require 'fitting/matchers/response_matcher'

module Fitting
  class Documentation
    class << self
      def try_on(response)
        response = Response.new(response, tomogram)
        [response.request, response]
      end

      private

      def tomogram
        @tomogram ||= TomogramRouting::Tomogram.craft(Fitting.configuration.tomogram)
      end
    end
  end
end
