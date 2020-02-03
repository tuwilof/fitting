module Fitting
  class Cover
    class JSONSchemaOneOf
      def initialize(json_schema)
        @json_schema = json_schema
        @combinations = []
      end

      def combi
        inception(@json_schema, @combinations).each do |combination|
          combination[0] = @json_schema.merge(combination[0])
          combination[1] = ['one_of', combination[1]]
        end
      end

      def inception(json_schema, combinations)
        json_schema.each do |key, value|
          if key == 'oneOf'
            one_of = json_schema.delete('oneOf')
            one_of.each_index do |index|
              combinations.push([json_schema.merge('oneOf' => [one_of[index]]), "oneOf.#{index}"])
            end
          elsif value.is_a?(Hash)
            inception(value, combinations)
            combinations.each do |combination|
              combination[0] = { key => combination[0]}
              combination[1] = "#{key}.#{combination[1]}"
            end
          end
        end

        combinations
      end
    end
  end
end
