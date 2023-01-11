module Fitting
  class Doc
    class Step
      def initialize(responses)
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

        @step = res2
      end

      def to_hash
        @step
      end

      def valid?

      end

      def increment!

      end

      def range

      end

      def next

      end
    end
  end
end
