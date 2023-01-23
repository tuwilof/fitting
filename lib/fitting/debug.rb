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

    def self.save!(docs, logs, yaml)
      res_logs = []
      res_debug = []
      res_docs = []
      return [] unless yaml['Debug']
      yaml['Debug'].map do |action|
        debug = new(action['host'], action['method'], action['path'], action['code'], action['content-type'])
        logs.each do |log|
          doc, res_log = Fitting::Doc.debug(docs, log, debug)
          res_docs.push(doc) if doc
          res_logs.push(res_log) if res_log
        end
        if docs
          doc = res_docs.first
          res_debug.push({doc_to_hash: doc.to_hash, doc_to_hash_lock: doc.to_hash_lock, res_logs: res_logs})
        end
      end
      File.open('coverage/.fitting.debug.json', 'w') { |file| file.write(::JSON.pretty_generate(res_debug)) }
    end
  end
end
