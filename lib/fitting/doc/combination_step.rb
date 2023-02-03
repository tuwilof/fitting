require 'fitting/doc/step'

module Fitting
  class Doc
    class CombinationStep < Step
      class NotFound < RuntimeError; end

      attr_accessor :json_schema, :type, :logs

      def initialize(json_schema, type, combination, source_json_schema)
        @logs = []
        @step_cover_size = 0
        @json_schema = json_schema
        @next_steps = []
        @type = type
        @step_key = combination
        @source_json_schema = source_json_schema
        initialize_combinations(combination, json_schema)
      end

      def initialize_combinations(combination, json_schema)
      end

      def debug_report(index)
        combinations = []
        @next_steps.each do |next_step|
          combinations.push(
            next_step.debug_report(index)
          )
        end
        return {} if index.nil? || index_before.nil?
        {
          "combination type" => @type,
          "combination" => @step_key,
          "json_schema" => @json_schema,
          "valid_jsons" => @logs,
          "index_before" => @index_before - index,
          "index_medium" => @index_medium - index,
          "index_after" => @index_after - index,
          "res_before" => @res_before.map { |r| r ? r : "null" }[index..-1],
          "res_medium" => @res_medium.map { |r| r ? r : "null" }[index..-1],
          "res_after" => @res_after.map { |r| r ? r : "null" }[index..-1],
          "combinations" => combinations
        }
      end
    end
  end
end
