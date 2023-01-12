require 'fitting/doc/step'

module Fitting
  class Doc
    class ContentType < Step
      def initialize(content_type, subvalue)
        @step_key = content_type
        if subvalue.size == 1
          @step_value = subvalue[0]['body']
        else
          @step_value =
            {
              "$schema" => "http://json-schema.org/draft-07/schema#",
              "type" => "object",
              "oneOf" => []
            }
          subvalue.each do |sv|
            @step_value["oneOf"].push(
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
end
