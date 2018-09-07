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
        @json_schemas, @combinations = super_each(@json_schema['properties'], { 'properties' => nil }, @json_schemas, @json_schema, @combinations)

        @json_schemas
      end

      def super_each(json_schema, old_keys_hash, lol_schemas, lol_schema, kekmbinations)
        json_schema.each do |key, value|
          new_keys_hash = clone_hash(old_keys_hash)
          add_super_key(new_keys_hash, key)
          next unless value.is_a?(Hash)
          lol_schemas, kekmbinations = super_each(value, new_keys_hash, lol_schemas, lol_schema, kekmbinations)
          kru, lol_schemas = modify_json_shema(value, new_keys_hash, lol_schemas, lol_schema)
          kekmbinations += kru
        end
        [lol_schemas, kekmbinations]
      end

      def add_super_key(vbn, new_key)
        vbn.each do |key, value|
          if value
            add_super_key(value, new_key)
          else
            vbn[key] = { new_key => nil }
          end
        end
      end

      def super_merge(vbn, asd, old_json_schema)
        vbn.each do |key, value|
          if value
            super_merge(value, asd, old_json_schema[key])
          else
            old_json_schema[key].merge!(asd)
          end
        end
        old_json_schema
      end

      def modify_json_shema(value, vbn, kek_schemas, kek_schema)
        qwe = required(value)
        qwe[0].map do |asd|
          new_json_shema = clone_hash(kek_schema)
          super_merge(vbn, asd, new_json_shema)
          kek_schemas += [new_json_shema]
        end
        [qwe[1], kek_schemas]
      end

      def clone_hash(old_json_schema)
        new_json_schema = {}
        old_json_schema.each do |key, value|
          if value.is_a?(Hash)
            new_json_schema.merge!(key => clone_hash(value))
          elsif value
            new_json_schema.merge!(key => value.clone)
          else
            new_json_schema.merge!(key => nil)
          end
        end
        new_json_schema
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
