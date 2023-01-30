module Fitting
  class NoCov
    class NotFound < RuntimeError; end

    def initialize(host, method, path, code, content_type, combination, combination_next)
      @host = host
      @method = method
      @path = path
      @code = code
      @content_type = content_type
      @combination = combination
      @combination_next = combination_next
    end

    def self.all(yaml)
      return [] unless yaml['NoCovUsedActions']
      yaml['NoCovUsedActions'].map do |action|
        new(action['host'], action['method'], action['path'], action['code'], action['content-type'], action['combination'], action['combination_next'])
      end
    end

    def find(docs)
      res = (docs[:provided] + docs[:used]).find do |action|
        action.host == @host && action.method == @method && action.path_match(@path)
      end

      if @code == nil
        return res if res.present?
        raise NotFound.new("host: #{@host}, method: #{@method}, path: #{@path}")
      end

      res_code = res.responses.find { |response| response.step_key == @code.to_s }

      if @content_type == nil
        return res_code if res_code.present?
        raise NotFound.new("host: #{@host}, method: #{@method}, path: #{@path}, code: #{@code}")
      end

      res_content_type = res_code.next_steps.find { |content_type| content_type.step_key == @content_type.to_s }

      if @combination == nil
        return res_content_type if res_content_type.present?
        raise NotFound.new("host: #{@host}, method: #{@method}, path: #{@path}, code: #{@code}, content-type: #{@content_type}")
      end

      res_json_schema = res_content_type.next_steps[0]
      res_combination = res_json_schema.next_steps.find do |combination|
        combination.step_key == @combination.to_s
      end

      if @combination_next == nil
        return res_combination if res_combination
        raise NotFound.new("host: #{@host}, method: #{@method}, path: #{@path}, code: #{@code}, content-type: #{@content_type}, combination: #{@combination}")
      end

      res_combination_next = res_combination.next_steps.find do |combination_next|
        combination_next.step_key == @combination_next.to_s
      end

      return res_combination_next if res_combination_next
      raise NotFound.new("host: #{@host}, method: #{@method}, path: #{@path}, code: #{@code}, content-type: #{@content_type}, combination: #{@combination}, combination_next: #{@combination_next}")
    end
  end
end
