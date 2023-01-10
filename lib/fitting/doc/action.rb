module Fitting
  class Doc
    class Action
      attr_accessor :type, :host, :prefix, :path, :method, :responses

      def initialize(type, host, prefix, method, path, responses)
        @type = type
        @host = host
        @prefix = prefix
        @method = method
        @path = path
        @responses = responses
        @key = "#{method} #{host}#{prefix}#{path}"

        @host_cover = 0
        @prefix_cover = 0
        @path_cover = 0
        @method_cover = 0
      end

      def to_hash_lock
        res2 = {}

        responses.group_by { |response| response['status'] }.each do |code, value|
          value.group_by { |val| val['content-type'] }.each do |content_type, subvalue|
            if subvalue.size == 1
              if res2[code] == nil
                res2.merge!(
                  {
                    code => {
                      content_type =>
                        subvalue[0]['body']
                    }
                  })
              elsif res2[code] != nil
                res2[code].merge!(
                  {
                    content_type =>
                      subvalue[0]['body']
                  })
              end
            else
              if res2[code] == nil
                res2.merge!(
                  {
                    code => {
                      content_type => {
                        "$schema" => "http://json-schema.org/draft-07/schema#",
                        "type" => "object",
                        "oneOf" => []
                      },
                    }
                  })
                subvalue.each do |sv|
                  res2[code][content_type]["oneOf"].push(
                    {
                      "properties" => sv['body']["properties"],
                      "required" => sv['body']["required"]
                    }
                  )
                end
              elsif res2[code] != nil
                res2[code].merge!(
                  {
                    content_type => {
                      "$schema" => "http://json-schema.org/draft-07/schema#",
                      "type" => "object",
                      "oneOf" => []
                    },
                  })
                subvalue.each do |sv|
                  res2[code][content_type]["oneOf"].push(
                    {
                      "properties" => sv['body']["properties"],
                      "required" => sv['body']["required"]
                    }
                  )
                end
              end
            end
          end
        end

        res = YAML.dump(
          {
            host => {
              prefix => {
                path => {
                  method => res2
                }
              }
            }
          }
        ).split("\n")
        { @key => res }
      end

      def to_hash
        res = [
          nil,
          @host_cover,
          @prefix_cover,
          @path_cover,
          @method_cover
        ]
        (to_hash_lock[@key].size - 5).times { res.push(nil) }
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

        true
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
