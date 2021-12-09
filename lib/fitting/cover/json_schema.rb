module Fitting
  class Cover
    class JSONSchema
      attr_reader :json_schema, :combinations

      def initialize(json_schema)
        @json_schema = json_schema
        @combinations = []
      end

      def combi
        inception(json_schema, combinations).each do |combination|
          combination[0] = json_schema.merge(combination[0])
          combination[1] = ['required', combination[1]]
        end
      end

      def inception(json_schema, combinations)
        json_schema.each do |key, value|
          if (key == 'properties') && (json_schema['required'] != value.keys)
            schema = json_schema.dup
            one_of = schema.delete('required') || []
            schema['properties'].each_key do |property|
              next if one_of.include?(property)

              combinations.push([schema.merge('required' => one_of + [property]), "required.#{property}"])
            end
          elsif value.is_a?(Hash)
            com = inception(value, [])
            com.each do |combination|
              combination[0] = { key => value.merge(combination[0]) }
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
