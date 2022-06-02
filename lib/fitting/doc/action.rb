module Fitting
  class Doc
    class Action
      attr_accessor :type, :host, :prefix, :method, :path

      def initialize(type, host, prefix, method, path)
        @type = type
        @host = host
        @prefix = prefix
        @method = method
        @path = path
      end

      def to_hash
        {
          host: host,
          prefix: prefix,
          method: method,
          path: path,
        }
      end

      def self.provided_all(apis)
        apis.map do |api|
          Tomograph::Tomogram.new(prefix: api['prefix'], tomogram_json_path: api['path']).to_a.map do |action|
            Fitting::Doc::Action.new(
              'provided',
              'www.example.com',
              api['prefix'],
              action.to_hash['method'],
              action.to_hash['path'].path
            )
          end
        end.flatten
      end

      def self.used_all(apis)
        apis.map do |api|
          Tomograph::Tomogram.new(prefix: '', tomogram_json_path: api['path']).to_a.map do |action|
            Fitting::Doc::Action.new(
              'used',
              api['host'],
              '',
              action.to_hash['method'],
              action.to_hash['path'].path
            )
          end
        end.flatten
      end

      def cover!(log)
        return unless log.host == host

        return unless prefix.empty? || log.path[0..prefix.size - 1] == prefix

        return unless path_match(log.path)

        return unless log.method == method

        log
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
    end
  end
end
