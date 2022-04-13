require 'fitting/report/actions'

module Fitting
  class Prefix
    KEYS = {
      'openapi2' => :openapi2_json_path,
      'openapi3' => :openapi3_yaml_path,
      'drafter' => :drafter_yaml_path,
      'crafter' => :crafter_yaml_path,
      'tomogram' => :tomogram_json_path
    }.freeze

    attr_reader :name, :actions

    def initialize(name, schema_paths, type, skip = false)
      @prefix = name
      @cover = false

      @actions = Fitting::Report::Actions.new([])
      raise Skip if skip

      schema_paths.each do |path|
        tomogram = Tomograph::Tomogram.new(prefix: name, KEYS[type] => path)

        @actions.push(Fitting::Report::Actions.new(tomogram))
      end
    end

    class Skip < RuntimeError; end

    class NotFound < RuntimeError
      attr_reader :log

      def initialize(msg, log)
        @log = log
        super(msg)
      end
    end

    def self.find(host:, log:)
      yaml = YAML.safe_load(File.read('.fitting.yml'))

      prefixes = yaml['hosts'].find{|h| h.first.first == host.to_s}.first.last['prefixes']
      raise NotFound.new("host: #{log.host}, path: #{log.path}", log) unless prefixes

      prefix = prefixes.find do |prefix|
        prefix['name'].nil? || log.path[0..prefix['name'].size - 1] == prefix['name']
      end
      raise NotFound.new("host: #{log.host}, path: #{log.path}", log) unless prefix

      new(prefix['name'], prefix['schema_paths'], prefix['type'], prefix['skip'])
    end

    def cover!
      @cover = true
    end

    def cover?
      @cover
    end
  end
end
