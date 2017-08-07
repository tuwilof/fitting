require 'fitting/records/tested'
require 'fitting/statistics'

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
        Fitting::Statistics.new(@tested)
      end
    end
  end
end
