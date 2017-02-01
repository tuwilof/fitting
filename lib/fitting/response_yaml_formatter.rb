require 'rspec/core/formatters/base_formatter'
require 'yaml'
require 'fitting/json_file'
require 'fitting/report/response'

module Fitting
  class ResponseYamlFormatter < RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self, :start, :stop

    def start(_notification)
      Fitting::YamlFile.craft
    end

    def stop(_notification)
      tests = Fitting::YamlFile.load
      Fitting::YamlFile.destroy

      report = Report::Response.new(tests).to_hash
      craft_json(report)
    end

    def craft_json(report)
      File.open('response_report.yaml', 'w') do |file|
        file.write(YAML.dump(report))
      end
    end
  end
end
