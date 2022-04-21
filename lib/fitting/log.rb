module Fitting
  class Log
    def initialize(log, type)
      @log = log
      @type = type
      @error = nil
    end

    def self.all(testlog)
      logs = []
      testlog.split("\n").select { |f| f.include?('incoming request ') }.each do |test|
        logs.push(new(JSON.load(test.split('incoming request ')[1]), 'incoming'))
      end
      testlog.split("\n").select { |f| f.include?('outgoing request ') }.each do |test|
        logs.push(new(JSON.load(test.split('outgoing request ')[1]), 'outgoing'))
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

    def type
      @type
    end

    def pending!
      print "\e[33m*\e[0m"
    end

    def failure!(error)
      @error = error
      print "\e[31mF\e[0m"
    end

    def error
      @error
    end

    def failure?
      @error.present?
    end

    def self.failure(logs)
      logs.select do |log|
        log.failure?
      end
    end

    def self.pending(logs) end

    def self.report(logs)
      Fitting::Log.failure(logs).each_with_index do |log, index|
        puts "\e[31m  #{index + 1}) #{log.error.class} #{log.error.message}\n\e[0m"
      end
      print "\e[31m#{logs.size} examples, #{Fitting::Log.failure(logs)} failure, #{Fitting::Log.pending(logs)} pending\e[0m"
    end
  end
end