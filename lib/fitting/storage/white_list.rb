module Fitting
  module Storage
    class WhiteList
      def initialize(white_list, resource_white_list, resources)
        @white_list = white_list
        @resource_white_list = resource_white_list
        @resources = resources
      end

      def to_a
        return @white_list if @white_list
        @white_list = transformation
      end

      def transformation
      end
    end
  end
end
