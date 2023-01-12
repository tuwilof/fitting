module Fitting
  class Doc
    class Step
      attr_accessor :step_cover_size, :step_value

      def next_steps

      end

      def to_hash
        {
          @step_key => @step_value
        }
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
