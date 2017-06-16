module Fitting
  class Cover
    class Response
      def initialize(response)
        @response = response
      end

      def update(_response)
        self
      end
    end
  end
end
