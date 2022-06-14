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
        @cover = 0
      end

      def url
        "#{@host}#{@prefix}#{@path}"
      end

      def to_hash
        {
          host: host,
          prefix: prefix,
          method: method,
          path: path,
        }
      end

      def to_yaml
        YAML.dump(to_hash)
      end

      def self.provided_all(apis)
        return [] unless apis
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
        return [] unless apis
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
        Rails.logger.debug "DOC NAME | #{method} #{url}"
        unless log.host == host
          Rails.logger.debug "FALSE | log.host == host | #{log.host} == #{host}"
          return
        end
        Rails.logger.debug "TRUE | log.host == host | #{log.host} == #{host}"
        @cover = 25 if @cover < 25

        unless prefix.size == 0 || log.path[0..prefix.size - 1] == prefix
          Rails.logger.debug "FALSE | prefix.size == 0 | prefix.size = #{prefix.size} || log.path[0..prefix.size - 1] == prefix | #{log.path[0..prefix.size - 1]} == #{prefix}"
          return
        end
        Rails.logger.debug "TRUE | prefix.size == 0 | prefix.size = #{prefix.size} || log.path[0..prefix.size - 1] == prefix | #{log.path[0..prefix.size - 1]} == #{prefix}"
        @cover = 50 if @cover < 50

        unless path_match(log.path)
          Rails.logger.debug "FALSE | path_match(log.path) | log.path = #{log.path} | path #{path}"
          return
        end
        Rails.logger.debug "TRUE | path_match(log.path) | log.path = #{log.path} | path #{path}"
        @cover = 75 if @cover < 75

        unless log.method == method
          Rails.logger.debug "FALSE | log.method == method | #{log.method} == #{method}"
          return
        end
        Rails.logger.debug "TRUE | log.method == method | #{log.method} == #{method}"
        @cover = 100 if @cover < 100
        true
      end

      def cover
        @cover
      end

      def nocover!
        @cover = 100
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
