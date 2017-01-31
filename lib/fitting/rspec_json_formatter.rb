require 'rspec/core/formatters/base_formatter'
require 'multi_json'
require 'fitting/json_file'
require 'fitting/report'

module Fitting
  class RspecJsonFormatter < RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self, :start, :stop

    def start(_notification)
      Fitting::YamlFile.save(Report.blank)
    end

    def stop(_notification)
      tests = Fitting::YamlFile.tests
      Fitting::YamlFile.destroy

      report = Report.new(tests).to_hash
      craft_json(report)
    end

    def craft_json(report)
      File.open('report.json', 'w') do |file|
        file.write(MultiJson.dump(report))
      end
    end
  end
end
