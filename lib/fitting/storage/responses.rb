require 'fitting/records/tested'
require 'fitting/statistics'
require 'fitting/storage/white_list'
require 'fitting/storage/documentation'
require 'fitting/records/documented'

module Fitting
  module Storage
    class Responses
      def initialize
        @tested = Fitting::Records::Tested.new
      end

      def add(env_response)
        @tested.add(env_response)
      end

      def statistics
        documented.join(@tested)
        Fitting::Statistics.new(documented)
      end

      def documented
        @documented ||= Fitting::Records::Documented.new(tomogram, white_list)
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
