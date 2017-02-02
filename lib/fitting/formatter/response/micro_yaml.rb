require 'rspec/core/formatters/base_formatter'
require 'yaml'
require 'fitting/json_file'
require 'fitting/report/response/micro'

module Fitting
  module Formatter
    module Response
      class MicroYaml < RSpec::Core::Formatters::BaseFormatter
        RSpec::Core::Formatters.register self, :start, :stop

        def start(_notification)
          Fitting::YamlFile.craft
        end

        def stop(_notification)
          tests = Fitting::YamlFile.load
          Fitting::YamlFile.destroy

          report = Report::Response::Micro.new(tests).to_hash
          craft_json(report)
        end

        def craft_json(report)
          File.open('report_response_micro.yaml', 'w') do |file|
            file.write(YAML.dump(report))
          end
        end
      end
    end
  end
end
