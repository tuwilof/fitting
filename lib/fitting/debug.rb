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
        res_debug = {
          "json_schema" => res.next_steps.first.to_hash,
          "lock" => doc_to_hash_lock,
          "logs" => res.logs
        }
        File.open('coverage/.fitting.debug.yml', 'w') { |file| file.write(YAML.dump(res_debug)) }
      end
    end
  end
end
