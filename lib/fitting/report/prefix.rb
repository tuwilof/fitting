require 'fitting/report/actions'

module Fitting
  module Report
    class Prefix
      def initialize(name: '', openapi2_json_path: nil, openapi3_yaml_path: nil, drafter_yaml_path: nil, tomogram_json_path: nil, crafter_yaml_path: nil, skip: false)
        @name = name
        @tomogram_json_path = tomogram_json_path
        @tests = Fitting::Report::Tests.new([])
        @skip = skip
        unless skip
          @actions = if openapi2_json_path
                       Fitting::Report::Actions.new(
                         Tomograph::Tomogram.new(
                           prefix: name,
                           openapi2_json_path: openapi2_json_path
                         )
                       )
                     elsif openapi3_yaml_path
                       Fitting::Report::Actions.new(
                         Tomograph::Tomogram.new(
                           prefix: name,
                           openapi3_yaml_path: openapi3_yaml_path
                         )
                       )
                     elsif drafter_yaml_path
                       Fitting::Report::Actions.new(
                         Tomograph::Tomogram.new(
                           prefix: name,
                           drafter_yaml_path: drafter_yaml_path
                         )
                       )
                     elsif crafter_yaml_path
                       Fitting::Report::Actions.new(
                         Tomograph::Tomogram.new(
                           prefix: name,
                           crafter_yaml_path: crafter_yaml_path
                         )
                       )
                     else
                       Fitting::Report::Actions.new(
                         Tomograph::Tomogram.new(
                           prefix: name,
                           tomogram_json_path: tomogram_json_path
                         )
                       )
                     end
        end
      end

      def name
        @name
      end

      def tests
        @tests
      end

      def skip?
        @skip
      end

      def actions
        @actions
      end

      def details
        if @skip
          {
              name: @name,
              tests_size: @tests.size,
              actions: {tests_without_actions: [], actions_details: []}
          }
        else
          {
              name: @name,
              tests_size: @tests.size,
              actions: @actions.details(self)
          }
        end
      end

      def add_test(test)
        @tests.push(test)
      end
    end
  end
end
