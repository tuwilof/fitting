module Fitting
  class NoCov
    attr_accessor :host, :method, :path

    def initialize(host, method, path)
      @host = host
      @method = method
      @path = path
    end

    def self.all(yaml)
      return [] unless yaml['NoCovUsedActions']
      yaml['NoCovUsedActions'].map do |action|
        new(action['host'], action['method'], action['path'])
      end
    end

    def find(docs)
      docs[:used].find do |action|
        action.host == host && action.method == method && action.path_match(path)
      end
    end
  end
end
