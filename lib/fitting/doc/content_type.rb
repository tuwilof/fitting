require 'fitting/doc/step'

module Fitting
  class Doc
    class ContentType < Step
      def initialize(content_type, subvalue)
        @step_cover_size = 0
        @step_key = content_type
        @next_steps = []
        if subvalue.size == 1
          @next_steps.push(subvalue[0]['body'])
        else
          @next_steps.push(
            {
              "$schema" => "http://json-schema.org/draft-07/schema#",
              "type" => "object",
              "oneOf" => []
            })
          subvalue.each do |sv|
            @next_steps[0]["oneOf"].push(
              {
                "properties" => sv['body']["properties"],
                "required" => sv['body']["required"]
              }
            )
          end
        end
      end

      def cover!(log)
        if @step_key == 'application/json'
          @step_cover_size += 1
        else
          @step_cover_size = nil
        end
      end

      def nocover!
        @step_cover_size = nil
      end
    end
  end
end
