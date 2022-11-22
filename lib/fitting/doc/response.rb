module Fitting
  class Doc
    class Response
      attr_accessor :code, :content_type, :body

      def initialize(code, content_type, bodies)
        @code = code
        @content_type = content_type
        @body = {
          "$schema"=>"http://json-schema.org/draft-04/schema#",
          "type"=>"object",
          "oneOf"=> bodies.map{|body| body.except("$schema")}
        }
      end

      def to_hash
        {
          code: code,
          content_type: content_type,
          body: body
        }
      end

      def self.all(responses)
        result = []
        responses.group_by{|response| response['status']}.each do |code, value|
          value.group_by{|val| val['content-type']}.each do |content_type, subvalue|
            result.push(new(code, content_type,  subvalue.map{|sub| sub['body']}))
          end
        end
        result
      end
    end
  end
end
