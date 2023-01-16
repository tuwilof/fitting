module Fitting
  class Doc
    class Step
      attr_accessor :step_cover_size, :step_key, :next_steps

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
        res[index] = @step_cover_size

        if @next_steps != []
          new_index = index + 1
          @next_steps.each do |next_step|
            res, new_index = next_step.report(res, new_index)
          end
        end

        index += YAML.dump(@next_steps.inject({}) { |sum, value| sum.merge!(value) }).split("\n").size
        [res, index]
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
