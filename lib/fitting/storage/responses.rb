module Fitting
  module Storage
    class Responses
      def initialize
        @responses = []
      end

      def push(test)
        @responses.push(test)
      end

      def all
        @responses.uniq
      end
    end
  end
end
