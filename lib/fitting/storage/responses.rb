require 'fitting/statistics'
require 'fitting/storage/white_list'
require 'fitting/storage/documentation'
require 'fitting/records/tested/request'
require 'fitting/records/documented/requests'

module Fitting
  module Storage
    class Responses
      def initialize
        @tested_requests = []
      end

      def add(env_response)
        @tested_requests.push(Fitting::Records::Tested::Request.new(env_response))
      end

      def statistics
        Fitting::Statistics.new(documented, @tested_requests)
      end

      def documented
        @documented_requests ||= Fitting::Records::Documented::Requests.new(tomogram, white_list)
      end

      def tomogram
        @tomogram ||= Fitting::Storage::Documentation.tomogram.to_hash
      end

      def white_list
        @white_list ||= Fitting::Storage::WhiteList.new(
          Fitting.configuration.white_list,
          Fitting.configuration.resource_white_list,
          Fitting::Storage::Documentation.tomogram.to_resources
        )
      end
    end
  end
end
