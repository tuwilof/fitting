module Fitting
  class NoCov
    class NotFound < RuntimeError; end

    def initialize(host, method, path, code)
      @host = host
      @method = method
      @path = path
      @code = code
    end

    def self.all(yaml)
      return [] unless yaml['NoCovUsedActions']
      yaml['NoCovUsedActions'].map do |action|
        new(action['host'], action['method'], action['path'], action['code'])
      end
    end

    def find(docs)
      res = docs[:used].find do |action|
        action.host == @host && action.method == @method && action.path_match(@path)
      end

      if @code == nil
        return res if res.present?
        raise NotFound.new("host: #{@host}, method: #{@method}, path: #{@path}")
      else
        res_code = res.responses.find { |response| response.step_key == @code.to_s }
        return res_code if res_code.present?
        raise NotFound.new("host: #{@host}, method: #{@method}, path: #{@path}, code: #{@code}")
      end
    end
  end
end
