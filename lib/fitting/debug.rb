module Fitting
  class Debug
    attr_accessor :host, :method, :path, :status, :content_type

    def initialize(host, method, path, code, content_type)
      @host = host
      @method = method
      @path = path
      @status = code.to_s
      @content_type = content_type
    end

    def self.save!(docs, yaml)
      return unless yaml['Debug']
      yaml['Debug'].map do |action|
        debug = new(action['host'], action['method'], action['path'], action['code'], action['content-type'])
        res = Fitting::Doc.debug(docs, debug)
        index = res.next_steps.first.index_before
        next_steps_first = res.next_steps.first
        res_debug = report(index, next_steps_first, res.logs)
        File.open('coverage/.fitting.debug.yml', 'w') { |file| file.write(YAML.dump(res_debug)) }
      end
    end

    def self.report(index, next_steps_first, res_logs)
      return {} if index.nil?
      combinations = []
      next_steps_first.next_steps.each do |next_step|
        combinations.push(
          next_step.debug_report(index)
        )
      end
      res_debug = {
        "json_schema" => next_steps_first.to_hash,
        "jsons" => res_logs,
        "valid_jsons" => next_steps_first.logs,
        "index_before" => next_steps_first.index_before - index,
        "index_medium" => next_steps_first.index_medium - index,
        "index_after" => next_steps_first.index_after - index,
        "res_before" => next_steps_first.res_before.map{|r| r ? r : "null"}[index..-1],
        "res_medium" => next_steps_first.res_medium.map{|r| r ? r : "null"}[index..-1],
        "res_after" => next_steps_first.res_after.map{|r| r ? r : "null"}[index..-1],
        "combinations" => combinations
      }
    end
  end
end
