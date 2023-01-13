require 'fitting/doc/step'
require 'fitting/doc/content_type'

module Fitting
  class Doc
    class Code < Step
      class NotFound < RuntimeError; end

      def initialize(code, value)
        @step_cover_size = 0
        @step_key = code
        @next_steps = []
        value.group_by { |val| val['content-type'] }.each do |content_type, subvalue|
          @next_steps.push(ContentType.new(content_type, subvalue))
        end
      end

      def cover!(log)
        if @step_key == log.status
          @step_cover_size += 1
          @next_steps.each { |content_type| content_type.cover!(log) }
        end
      rescue Fitting::Doc::ContentType::NotFound => e
        raise NotFound.new "code: #{@step_key}\n\n"\
          "#{e.message}"
      end
    end
  end
end
