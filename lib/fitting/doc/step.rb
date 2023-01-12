module Fitting
  class Doc
    class Step
      attr_accessor :step_cover_size, :step_value, :step_key

      def to_hash
        {
          @step_key => @step_value
        }
      end

      def nocover!
        @step_cover_size = nil
      end

      def next_steps
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
