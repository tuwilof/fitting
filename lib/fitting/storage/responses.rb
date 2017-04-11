module Fitting
  module Storage
    class Responses
      def initialize
        @responses = []
      end

      def add(response)
        @responses.push(
          Fitting::Response.new(
            response,
            Fitting::Storage::Documentation.tomogram))
      end

      def statistics
        Fitting::Statistics.new(
          Fitting::Documentation.new(
            Fitting::Storage::Documentation.tomogram,
            Fitting.configuration.white_list),
          @responses.uniq,
          Fitting.configuration.strict
        )
      end
    end
  end
end
