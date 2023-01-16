require 'fitting/doc/step'
require 'fitting/doc/json_schema'

module Fitting
  class Doc
    class ContentType < Step
      class NotFound < RuntimeError; end

      def initialize(content_type, subvalue)
        @step_key = content_type
        @next_steps = []
        @step_cover_size = 0
        return self if content_type != 'application/json'
        if subvalue.size == 1
          @next_steps.push(JsonSchema.new(subvalue[0]['body']))
        else
          definitions = subvalue.inject({}) do |sum, sv|
            if sv['body']["definitions"] != nil
              sum.merge!(sv['body']["definitions"])
            end
            sum
          end
          if definitions && definitions != {}
            @next_steps.push(JsonSchema.new(
              {
                "$schema" => "http://json-schema.org/draft-04/schema#",
                "definitions" => definitions,
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
            ))
          else
            @next_steps.push(JsonSchema.new(
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
            ))
          end
        end
      end

      def cover!(log)
        if @step_key == log.content_type && log.content_type == 'application/json'
          @step_cover_size += 1
          @next_steps.each { |json_schema| json_schema.cover!(log) }
        elsif @step_key != 'application/json' && log.content_type != 'application/json'
          @step_cover_size += 1
        end
      rescue Fitting::Doc::JsonSchema::NotFound => e
        raise NotFound.new "content-type: #{@step_key}\n\n"\
          "#{e.message}"
      end
    end
  end
end
