module Fitting
  class Host
    class Skip < RuntimeError; end
    class NotFound < RuntimeError
      attr_reader :log
      def initialize(msg, log)
        @log = log
        super(msg)
      end
    end

    def initialize(host, skip)
      @host = host
      @skip = skip
      @cover = false
    end

    def self.find!(log)
      yaml = YAML.safe_load(File.read('.fitting.yml'))
      yaml['hosts']&.map do |host|
        if log.host == host.first.first
          return new(host.first.first, host.first.last)
        end
      end
      raise NotFound.new(log.host, log)
    end

    def cover!
      @cover = true
      raise Skip if @skip == 'skip'
    end

    def to_s
      @host
    end
  end
end