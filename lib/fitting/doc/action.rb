require 'fitting/doc/code'
require 'fitting/debug'

module Fitting
  class Doc
    class Action
      attr_accessor :type, :host, :prefix, :path, :method, :responses

      class NotFound < RuntimeError; end

      def initialize(type, host, prefix, method, path, responses)
        @type = type
        @host = host
        @prefix = prefix
        @method = method
        @path = path
        @responses = []
        responses.group_by { |response| response['status'] }.each do |code, value|
          @responses.push(Code.new(code, value))
        end
        @key = "#{method} #{host}#{prefix}#{path}"

        @host_cover = 0
        @prefix_cover = 0
        @path_cover = 0
        @method_cover = 0
      end

      def to_hash_lock
        res = YAML.dump(
          {
            host => {
              prefix => {
                path => {
                  method => @responses.inject({}) { |sum, response| sum.merge!(response) }
                }
              }
            }
          }
        ).split("\n")
        { @key => res[1..-1] }
      end

      def to_hash
        res = [
          @host_cover,
          @prefix_cover,
          @path_cover,
          @method_cover
        ]
        (to_hash_lock[@key].size - 4).times { res.push(nil) }

        if @method_cover != nil && @method_cover != 0
          code_index = 4
          @responses.each do |code|
            res, code_index = code.report(res, code_index)
          end
        end

        { @key => res }
      end

      def self.provided_all(apis)
        return [] unless apis
        apis.map do |api|
          Tomograph::Tomogram.new(prefix: api['prefix'], tomogram_json_path: api['path']).to_a.map do |action|
            new(
              'provided',
              YAML.safe_load(File.read('.fitting.yml'))['Host'],
              api['prefix'],
              action.to_hash['method'],
              action.to_hash['path'].path,
              action.responses
            )
          end
        end.flatten
      end

      def self.used_all(apis)
        return [] unless apis
        apis.map do |api|
          Tomograph::Tomogram.new(prefix: '', tomogram_json_path: api['path']).to_a.map do |action|
            new(
              'used',
              api['host'],
              '',
              action.to_hash['method'],
              action.to_hash['path'].path,
              action.responses
            )
          end
        end.flatten
      end

      def cover!(log)
        unless log.host == host
          return
        end
        @host_cover += 1

        unless prefix.size == 0 || log.path[0..prefix.size - 1] == prefix
          return
        end
        @prefix_cover += 1

        unless path_match(log.path)
          return
        end
        @path_cover += 1

        unless log.method == method
          return
        end
        @method_cover += 1

        @responses.each { |response| response.cover!(log) }

        true
      rescue Fitting::Doc::Code::NotFound => e
        raise NotFound.new "\n\ntype: #{@type}\n"\
          "host: #{@host}\n" \
          "prefix: #{@prefix}\n" \
          "method: #{@method}\n" \
          "path: #{@path}\n" \
          "#{e.message}"
      end

      def debug(debug)
        unless debug.host == host
          return nil
        end

        unless prefix.size == 0 || debug.path[0..prefix.size - 1] == prefix
          return nil
        end

        unless path_match(debug.path)
          return nil
        end

        unless debug.method == method
          return nil
        end

        @responses.each do |response|
          res = response.debug(debug)
          return res if res
        end
        nil
      end

      def nocover!
        @host_cover = nil
        @prefix_cover = nil
        @path_cover = nil
        @method_cover = nil
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
