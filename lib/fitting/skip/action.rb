module Fitting
  class Skip
    class Action
      attr_accessor :host, :method, :path

      def initialize(host, method, path)
        @host = host
        @method = method
        @path = path
      end

      def self.all(yaml)
        yaml['SkipUsedActions'].map do |action|
          new(action['host'], action['method'], action['path'])
        end
      end

      def self.find(actions, log)
        actions.find do |action|
          if action.host == log.host &&
            action.method == log.method &&
            action.path_match(log.path)
            return action
          end
        end
      end

      def path_match(find_path)
        regexp =~ find_path
      end

      def regexp
        str = Regexp.escape(path)
        str = str.gsub(/\\{\w+\\}/, '[^&=\/]+')
        str = "\\A#{str}\\z"
        Regexp.new(str)
      end
    end
  end
end
