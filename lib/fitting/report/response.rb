require 'fitting/statistics/template_cover_error'
require 'fitting/statistics/template_cover_error_enum'
require 'fitting/statistics/template_cover_error_one_of'
require 'fitting/report/combinations'

module Fitting
  module Report
    class Response
      def initialize(response)
        @response = response
        @tests = Fitting::Report::Tests.new([])
      end

      def status
        @response['status']
      end

      def body
        @response['body']
      end

      def add_test(test)
        @tests.push(test)
      end

      def tests
        @tests
      end

      def combinations
        return @combinations if @combinations

        cmbntns = []
        combinations = Fitting::Cover::JSONSchema.new(body).combi + Fitting::Cover::JSONSchemaEnum.new(body).combi + Fitting::Cover::JSONSchemaOneOf.new(body).combi
        if combinations != []
          combinations.map do |combination|
            cmbntns.push(
                {
                    'json_schema' => combination[0],
                    'type' => combination[1][0],
                    'combination' => combination[1][1],
                    'tests' => [],
                    'error' => []
                }
            )
          end
        end

        @combinations = Fitting::Report::Combinations.new(cmbntns)
      end
    end
  end
end
