module Fitting
  module Matchers
    class Response
      def matches?(actual)
        @data = Fitting::Documentation.response(actual[0], actual[1])
        @data["valid"] == true
      end

      def ===(other)
        matches?(other)
      end

      def failure_message
        if @data["valid"].nil?
          "response not documented\n"
        else
          fvs = ""
          @data["fully_validates"].map { |fv| fvs += "#{fv}\n" }
          shcs = ""
          @data["schemas"].map { |shc| shcs += "#{shc}\n" }
          "response not valid json-schema\n"\
        "got: #{@data["body"]}\n"\
        "diff: \n#{fvs}"\
        "expected: \n#{shcs}\n"
        end
      end
    end

    def match_response
      Response.new
    end
  end
end
