module Fitting
  module Report
    class Combination
      def initialize(json_schema:, type:, combination:)
        @json_schema = json_schema
        @type = type
        @combination = combination
        @id = SecureRandom.hex
        @cover = false
      end

      attr_reader :json_schema, :id, :type

      def cover?
        @cover
      end

      def cover!
        @cover = true
      end

      def name
        @combination
      end
    end
  end
end
