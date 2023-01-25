module Fitting
  class Doc
    class Step
      attr_accessor :step_cover_size, :step_key, :next_steps, :index_before, :index_medium, :index_after, :res_before, :res_medium, :res_after

      def to_hash
        {
          @step_key => @next_steps.inject({}) { |sum, value| sum.merge!(value) }
        }
      end

      def nocover!
        @step_cover_size = nil
        @next_steps.each do |next_step|
          next_step.nocover!
        end
      end

      def report(res, index)
        @index_before = index
        @res_before = [] + res

        mark_range(index, res)
        @index_medium = index
        @res_medium = [] + res

        if @next_steps != []
          new_index = index + new_index_offset
          @next_steps.each do |next_step|
            res, new_index = next_step.report(res, new_index)
          end
        end

        index += index_offset
        @index_after = index
        @res_after = [] + res
        [res, index]
      end

      def mark_range(index, res)
        res[index] = @step_cover_size
        if @json_schema && @json_schema["required"]
          mark_required(index, res, @json_schema)
        end
      end

      def new_index_offset
        1
      end

      def index_offset
        YAML.dump(@next_steps.inject({}) { |sum, value| sum.merge!(value) }).split("\n").size
      end

      def mark_required(index, res, schema)
        start_index = index + YAML.dump(schema["properties"]).split("\n").size
        end_index = start_index + YAML.dump(schema["required"]).split("\n").size - 1
        (start_index..end_index).each do |i|
          res[i] = @step_cover_size
        end

        return if schema["required"].nil?

        schema["required"].each do |required|
          required_index = YAML.dump(schema["properties"]).split("\n").index { |key| key == "#{required}:" }
          break if required_index.nil?
          res[index + required_index] = @step_cover_size
          res[index + required_index + 1] = @step_cover_size
          res[index + required_index + 2] = @step_cover_size if schema["properties"][required]["type"] == "string" && schema["properties"][required]["enum"]
          if schema["properties"][required]["type"] == "object"
            res[index + required_index + 2] = @step_cover_size
            new_index = index + required_index + 2
            mark_required(new_index, res, schema["properties"][required])
          elsif schema["properties"][required]["type"] == "string" && schema["properties"][required]["enum"]
            new_index = index + required_index + 2
            mark_enum(new_index, res, schema["properties"][required])
          end
        end
      end

      def mark_enum(index, res, schema)
        if schema["enum"].size == 1
          res[index] = @step_cover_size
          res[index + 1] = @step_cover_size
        end
      end

      def valid?
      end

      def range
      end

      def next
      end
    end
  end
end
