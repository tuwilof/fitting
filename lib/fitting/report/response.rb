require 'fitting/statistics/template_cover_error'
require 'fitting/statistics/template_cover_error_enum'
require 'fitting/statistics/template_cover_error_one_of'
require 'fitting/report/combinations'
require 'fitting/report/combination'

module Fitting
  module Report
    class Response
      def initialize(response)
        @response = response
        @tests = Fitting::Report::Tests.new([])
        @id = SecureRandom.hex
      end

      def status
        @response['status']
      end

      def body
        @response['body']
      end

      def id
        @id
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
                Fitting::Report::Combination.new(
                    json_schema: combination[0],
                    type: combination[1][0],
                    combination: combination[1][1]
                )
            )
          end
        end

        @combinations = Fitting::Report::Combinations.new(cmbntns)
      end

      def cover_percent
        return '0%' if @tests.size == 0
        return '100%' if @combinations.size == 0
        "#{(@combinations.size_with_tests + 1) * 100 / (@combinations.size + 1)}%"
      end

      def details
        {
            cover_percent: cover_percent,
            tests_without_combinations: @tests.without_combinations,
            combinations_details: @combinations.to_a.map { |c| {json_schema: c.id, tests_size: c.tests.size, type: c.type, name: c.name} }
        }
      end
    end
  end
end
