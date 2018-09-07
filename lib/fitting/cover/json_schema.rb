module Fitting
  class Cover
    class JSONSchema
      def initialize(json_schema)
        @json_schema = json_schema
      end

      def combi
        return @combinations if @combinations
        @combinations = new_required(@json_schema)

        return @combinations unless @json_schema['properties']
        @combinations = new_super_each(@json_schema['properties'], { 'properties' => nil }, @json_schema, @combinations, 'properties')

        @combinations
      end

      def new_super_each(json_schema, old_keys_hash, lol_schema, combinations, old_key)
        json_schema.each do |key, value|
          next unless value.is_a?(Hash)

          new_keys_hash = clone_hash(old_keys_hash)
          add_super_key(new_keys_hash, key)

          combinations = new_super_each(value, new_keys_hash, lol_schema, combinations, [old_key, key].compact.join('.'))

          qwe = new_required(value)
          qwe.map do |asd|
            new_json_shema = clone_hash(lol_schema)
            super_merge(new_keys_hash, asd[0], new_json_shema)
            combinations.push([new_json_shema, [asd[1][0], [old_key, key, asd[1][1]].compact.join('.')]])
          end
        end
        combinations
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

      def new_required(json_schema)
        res = []
        new_keys(json_schema).map do |new_key|
          new_json_shema = json_schema.dup
          if new_json_shema['required']
            new_json_shema['required'] += [new_key]
          else
            new_json_shema['required'] = [new_key]
          end
          res.push([new_json_shema, ['required', new_key]])
        end
        res
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
