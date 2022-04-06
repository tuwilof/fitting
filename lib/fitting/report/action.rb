require 'fitting/report/responses'

module Fitting
  module Report
    class Action
      def initialize(action)
        @action = action
        @responses = Fitting::Report::Responses.new(@action.responses)
        @cover = false
      end

      def cover?
        @cover
      end

      def mark!(test)
        @cover = true
      end

      def method
        @action.method
      end

      def path
        @action.path.to_s
      end

      attr_reader :responses, :tests

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
    end
  end
end
