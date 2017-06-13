require 'fitting/storage/white_list'

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
            Fitting::Storage::Documentation.tomogram
          )
        )
      end

      def statistics
        @white_list = Fitting::Storage::WhiteList.new(
          Fitting.configuration.white_list,
          Fitting.configuration.resource_white_list,
          Fitting::Storage::Documentation.tomogram.to_resources
        ).to_a
        Fitting::Statistics.new(
          Fitting::Documentation.new(
            Fitting::Storage::Documentation.tomogram,
            @white_list
          ),
          @responses.uniq,
          Fitting.configuration.strict
        )
      end
    end
  end
end
