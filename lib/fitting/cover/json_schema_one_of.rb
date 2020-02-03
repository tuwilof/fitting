module Fitting
  class Cover
    class JSONSchemaOneOf
      def initialize(json_schema)
        @json_schema = json_schema
      end

      def combi
        @combinations = []

        return @combinations unless @json_schema['oneOf'] || @json_schema['allOf']

        if @json_schema['oneOf']
          one_of = @json_schema.delete("oneOf")
          one_of.each_index do |index|
            @combinations.push([@json_schema.merge('oneOf' => [one_of[index]]), ['one_of', "#{index}"]])
          end
        elsif @json_schema['allOf']
          all_of = @json_schema.delete("allOf")
          one_of = all_of[0].delete("oneOf")
          one_of.each_index do |index|
            @combinations.push([@json_schema.merge(one_of[index]), ['one_of', "properties.#{index}"]])
          end
        end

        @combinations
      end
    end
  end
end
