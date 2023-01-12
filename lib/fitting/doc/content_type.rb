require 'fitting/doc/step'
require 'fitting/doc/json_schema'

module Fitting
  class Doc
    class ContentType < Step
      def initialize(content_type, subvalue)
        @step_cover_size = 0
        @step_key = content_type
        if subvalue.size == 1
          @next_steps = [JsonSchema.new(subvalue[0]['body'])]
        else
          @next_steps = [JsonSchema.new(
            {
              "$schema" => "http://json-schema.org/draft-04/schema#",
              "type" => "object",
              "oneOf" => subvalue.inject([]) do |sum, sv|
                if sv['body']["required"] == nil
                  sum.push(
                    {
                      "properties" => sv['body']["properties"]
                    }
                  )
                else
                  sum.push(
                    {
                      "properties" => sv['body']["properties"],
                      "required" => sv['body']["required"]
                    }
                  )
                end
              end
            }
          )]
        end
      end

      def cover!(log)
        if @step_key == 'application/json'
          @step_cover_size += 1
          @next_steps.each { |json_schema| json_schema.cover!(log) }
        else
          nocover!
        end
      end
    end
  end
end
