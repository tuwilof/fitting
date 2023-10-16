module Fitting
  class Log
    def initialize(log, type)
      @log = log
      @type = type
      @error = nil
      @skip = false
    end

    def self.all
      logs = []
      Dir["log/fitting*.log"].each do |file_path|
        testlog = File.read(file_path)
        testlog.split("\n").select { |f| f.include?('incoming request ') }.each do |test|
          logs.push(new(JSON.load(test.split('incoming request ')[1]), 'incoming'))
        end
        testlog.split("\n").select { |f| f.include?('outgoing request ') }.each do |test|
          logs.push(new(JSON.load(test.split('outgoing request ')[1]), 'outgoing'))
        end
      end
      logs.sort { |a, b| b.path <=> a.path }
    end

    def url
      "#{host}#{path}"
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

    def content_type
      @log['response']['content_type']
    end

    def host
      @log['host'] || 'www.example.com'
    end

    def type
      @type
    end

    def access!
      print "\e[32m.\e[0m"
    end

    def pending!
      @skip = true
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

    def pending?
      @skip
    end

    def self.pending(logs)
      logs.select do |log|
        log.pending?
      end
    end

    def self.report(logs)
      puts "\n\n"
      Fitting::Log.failure(logs).each_with_index do |log, index|
        puts "\e[31m  #{index + 1}) #{log.error.class} #{log.error.message}\n\n\e[0m"
      end
      print "\e[31m#{logs.size} examples, #{Fitting::Log.failure(logs).size} failure, #{Fitting::Log.pending(logs).size} pending\e[0m\n"
      unless Fitting::Log.failure(logs).size <= 0
        exit 1
      end
    end
  end
end