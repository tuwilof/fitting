require 'json'

module Fitting
  class Records
    class Spherical
      class Response
        attr_reader :status, :body

        def initialize(status:, body:, content_type:)
          @status = status
          @body = body
          @content_type = content_type
        end

        def to_hash
          begin
            parse_body =  JSON.parse(body)
          rescue JSON::ParserError
            parse_body = {}
          end

          if @content_type == nil || @content_type == ''
            {
              status: status,
              content_type: 'application/json',
              body: parse_body
            }
          else
            ct = @content_type.split("; ")
            {
              status: status,
              content_type: ct.first,
              body: parse_body
            }
          end
        end

        def to_json(*_args)
          JSON.dump(to_hash)
        end
      end
    end
  end
end
