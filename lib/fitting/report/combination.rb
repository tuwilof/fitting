module Fitting
  module Report
    class Combination
      def initialize(json_schema:, type:, combination:)
        @json_schema = json_schema
        @type = type
        @combination = combination
        @test = []
        @error = []
      end
    end
  end
end
