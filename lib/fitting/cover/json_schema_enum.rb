module Fitting
  class Cover
    class JSONSchemaEnum
      def initialize(json_schema)
        @json_schema = json_schema
        @combinations = []
      end

      def combi
        inception(@json_schema, @combinations).each do |combination|
          combination[0] = @json_schema.merge(combination[0])
          combination[1] = ['enum', combination[1]]
        end
      end

      def inception(json_schema, combinations)
        json_schema.each do |key, value|
          if key == 'enum' && value.size > 1
            schema = json_schema.dup
            one_of = schema.delete('enum')
            one_of.each_index do |index|
              combinations.push([schema.merge('enum' => [one_of[index]]), "enum.#{one_of[index]}"])
            end
          elsif value.is_a?(Hash)
            com = inception(value, [])
            com.each do |combination|
              combination[0] = { key => value.merge(combination[0])}
              combination[1] = "#{key}.#{combination[1]}"
            end
            combinations += com
          end
        end

        combinations
      end
    end
  end
end
