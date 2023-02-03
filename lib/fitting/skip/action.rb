module Fitting
  class Skip
    class Action
      attr_accessor :host, :method, :path, :code

      def initialize(host, method, path, code)
        @host = host
        @method = method
        @path = path
        @code = code
      end

      def self.all(actions)
        return [] unless actions
        actions.map do |action|
          next if action['method'].nil? || action['path'].nil?
          new(action['host'], action['method'], action['path'], action['code'])
        end.compact
      end

      def self.find(actions, log)
        actions.find do |action|
          if action.host == log.host &&
            action.method == log.method &&
            action.path_match(log.path)
            return action if action.code == nil
            return action if action.code.to_s == log.status
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
