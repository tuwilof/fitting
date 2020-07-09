module Fitting
  module Report
    class Action
      def initialize(action)
        @action = action
        @tests = []
      end

      def method
        @action.method
      end

      def path
        @action.path.to_s
      end

      def add_test(test)
        @tests.push(test)
      end

      def path_match(find_path)
        regexp =~ find_path
      end

      def regexp
        return @regexp if @regexp

        str = Regexp.escape(path)
        str = str.gsub(/\\{\w+\\}/, '[^&=\/]+')
        str = "\\A#{str}\\z"
        @regexp = Regexp.new(str)
      end

      def tests
        @tests
      end
    end
  end
end
