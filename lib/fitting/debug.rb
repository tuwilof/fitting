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
        combinations = []
        index = res.next_steps.first.index_before
        res.next_steps.first.next_steps.each do |next_step|
          combinations.push(
            {
              "combination type" => next_step.type,
              "combination" => next_step.step_key,
              "json_schema" => next_step.json_schema,
              "valid_jsons" => next_step.logs,
              "index_before" => next_step.index_before - index,
              "index_after" => next_step.index_after - index,
              "res_before" => next_step.res_before.map{|r| r ? r : "null"}[index..-1],
              "res_medium" => next_step.res_medium.map{|r| r ? r : "null"}[index..-1],
              "res_after" => next_step.res_after.map{|r| r ? r : "null"}[index..-1]
            }
          )

        end
        res_debug = {
          "json_schema" => res.next_steps.first.to_hash,
          "jsons" => res.logs,
          "valid_jsons" => res.next_steps.first.logs,
          "index_before" => res.next_steps.first.index_before - index,
          "index_after" => res.next_steps.first.index_after - index,
          "res_before" => res.next_steps.first.res_before.map{|r| r ? r : "null"}[index..-1],
          "res_medium" => res.next_steps.first.res_medium.map{|r| r ? r : "null"}[index..-1],
          "res_after" => res.next_steps.first.res_after.map{|r| r ? r : "null"}[index..-1],
          "combinations" => combinations
        }
        File.open('coverage/.fitting.debug.yml', 'w') { |file| file.write(YAML.dump(res_debug)) }
      end
    end
  end
end
