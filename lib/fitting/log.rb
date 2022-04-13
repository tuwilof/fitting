module Fitting
  class Log
    def initialize(log)
      @log = log
    end

    def self.all
      logs = []
      File.read('log/test.log').split("\n").select { |f| f.include?('incoming request ') }.each do |test|
        logs.push(new(JSON.load(test.split('incoming request ')[1])))
      end
      File.read('log/test.log').split("\n").select { |f| f.include?('outgoing request ') }.each do |test|
        logs.push(new(JSON.load(test.split('outgoing request ')[1])))
      end
      logs.sort { |a, b| b.path <=> a.path }
    end

    def path
      @log['path']
    end

    def method
      @log['method']
    end

    def status
      @log['response']['status'].to_s
    end

    def body
      @log['response']['body']
    end

    def host
      @log['host']
    end
  end
end