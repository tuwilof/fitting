module Fitting
  class Cover
    class JSONSchema
      def initialize(json_schema)
        @json_schema = json_schema
      end

      def json_schemas
        return @json_schemas if @json_schemas
        @json_schemas, @combinations = required(@json_schema)

        return @json_schemas unless @json_schema['properties']
        keys = @json_schema['properties'].keys
        keys.map do |key|
          if @json_schema['properties'][key]['properties']
            qwe = required(@json_schema['properties'][key])
            qwe[0].map do |asd|
              new_json_shema = {}
              @json_schema.each do |jkey, jvalue|
                new_json_shema.merge!(jkey => jvalue.clone)
              end
              new_json_shema['properties'][key] = asd
              @json_schemas += [new_json_shema]
            end
            @combinations += qwe[1]
          elsif @json_schema['properties'][key]['items']
            qwe = required(@json_schema['properties'][key]['items'])
            qwe[0].map do |asd|
              new_json_shema = {}
              @json_schema.each do |jkey, jvalue|
                if jvalue.is_a?(Hash)
                  jj_schema = {}
                  jvalue.each do |jjkey, jjvalue|
                    if key == jjkey
                      jj_schema.merge!(jjkey => jjvalue.clone)
                    else
                      jj_schema.merge!(jvalue.clone)
                    end
                  end
                  new_json_shema.merge!(jkey => jj_schema)
                else
                  new_json_shema.merge!(jkey => jvalue.clone)
                end
              end
              new_json_shema['properties'][key]['items'] = asd
              @json_schemas += [new_json_shema]
            end
            @combinations += qwe[1]
          end
        end

        @json_schemas
      end

      def combinations
        json_schemas
        @combinations
      end

      def required(json_schema)
        combinations = []
        json_schemas = new_keys(json_schema).inject([]) do |new_json_shemas, new_key|
          new_json_shema = json_schema.dup
          if new_json_shema['required']
            new_json_shema['required'] += [new_key]
          else
            new_json_shema['required'] = [new_key]
          end
          combinations.push(['required', new_key])
          new_json_shemas.push(new_json_shema)
        end
        [json_schemas, combinations]
      end

      def new_keys(json_schema)
        return [] unless json_schema && json_schema['properties']
        all = json_schema['properties'].keys.map(&:to_s)
        old = json_schema['required']
        if old
          all - old
        else
          all
        end
      end
    end
  end
end
