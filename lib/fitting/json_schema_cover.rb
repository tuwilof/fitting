module Fitting
  class JSONSchemaCover
    def initialize(json_schema)
      @json_schema = json_schema
      @combinations = []
    end

    def json_schemas
      @json_schemas ||= required
    end

    def combinations
      json_schemas
      @combinations
    end

    def required
      new_keys.inject([]) do |new_json_shemas, new_key|
        new_json_shema = @json_schema.dup
        new_json_shema[:required] += [new_key]
        @combinations.push(['required', new_key])
        new_json_shemas.push(new_json_shema)
      end
    end

    def new_keys
      all = @json_schema[:properties].keys.map(&:to_s)
      old = @json_schema[:required]
      all - old
    end
  end
end
