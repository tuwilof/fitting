require 'fitting/doc/step'
require 'fitting/doc/content_type'

module Fitting
  class Doc
    class Code < Step
      def initialize(code, value)
        @step_cover_size = 0
        @step_key = code
        @step_value = {}
        value.group_by { |val| val['content-type'] }.each do |content_type, subvalue|
          @step_value.merge!(ContentType.new(content_type, subvalue))
        end
      end

      def cover!(log)
        @step_cover_size += 1 if @step_key == log.status
      end
    end
  end
end
