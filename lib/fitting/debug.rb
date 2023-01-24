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
      yaml['Debug'].map do |action|
        debug = new(action['host'], action['method'], action['path'], action['code'], action['content-type'])
        res = Fitting::Doc.debug(docs, debug)
        doc_to_hash_lock = []
        res.next_steps.first.report(doc_to_hash_lock, 0)
        combinations = []
        res.next_steps.first.next_steps.each do |next_step|
          doc_to_hash_lock = []
          combinations.push(
            {
              "combination type" => next_step.type,
              "combination" => next_step.step_key,
              "json_schema" => next_step.json_schema,
              "lock" => next_step.report(doc_to_hash_lock, 0),
              "valid_jsons" => next_step.logs
            }
          )

        end
        res_debug = {
          "json_schema" => res.next_steps.first.to_hash,
          "lock" => doc_to_hash_lock,
          "jsons" => res.logs,
          "valid_jsons" => res.next_steps.first.logs,
          "combinations" => combinations
        }
        File.open('coverage/.fitting.debug.yml', 'w') { |file| file.write(YAML.dump(res_debug)) }
      end
    end
  end
end
