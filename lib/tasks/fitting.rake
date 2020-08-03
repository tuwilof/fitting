require 'fitting/records/spherical/requests'
require 'fitting/configuration'
require 'fitting/records/realized_unit'
require 'fitting/templates/realized_template'
require 'fitting/statistics/template_cover_error'
require 'fitting/statistics/template_cover_error_enum'
require 'fitting/statistics/template_cover_error_one_of'
require 'fitting/cover/json_schema'
require 'fitting/report/prefixes'
require 'fitting/report/tests'

namespace :fitting do
  task :report do
    tests = Fitting::Report::Tests.new_from_config('fitting_tests/*.json')
    prefixes = Fitting::Report::Prefixes.new('.fitting.yml')

    prefixes.join(tests)

    prefixes.to_a.map do |prefix|
      prefix.actions.join(prefix.tests) unless prefix.skip?
    end

    prefixes.to_a.map do |prefix|
      prefix.actions.to_a.map do |action|
        action.responses.join(action.tests)
      end unless prefix.skip?
    end

    report = JSON.pretty_generate(
        {
            tests_without_prefixes: tests.without_prefixes,
            prefixes_details: prefixes.to_a.map { |p| p.details }
        }
    )

    destination = 'fitting'
    FileUtils.rm_r Dir.glob("#{destination}/*"), :force => true
    File.open('fitting/report.json', 'w') { |file| file.write(report) }

    gem_path = $LOAD_PATH.find { |i| i.include?('fitting') }
    source_path = "#{gem_path}/templates/bomboniere/dist"
    FileUtils.copy_entry source_path, destination

    js_path =  Dir["#{destination}/js/*"].find { |f| f[0..14] == 'fitting/js/app.' and f[-3..-1] == '.js' }
    js_file =  File.read(js_path)
    new_js_file = js_file.gsub("{stub:\"prefixes report\"}", report)
    File.open(js_path, 'w') { |file| file.write(new_js_file) }

    exit 0

    actions.map do |action|
      action.to_hash["responses"].map do |response|
        response['combination'] ||= []
        combinations = Fitting::Cover::JSONSchema.new(response['body']).combi + Fitting::Cover::JSONSchemaEnum.new(response['body']).combi + Fitting::Cover::JSONSchemaOneOf.new(response['body']).combi
        if combinations != []
          combinations.map do |combination|
            response['combination'].push(
                {
                    'json_schema' => combination[0],
                    'type' => combination[1][0],
                    'combination' => combination[1][1],
                    'tests' => [],
                    'error' => []
                }
            )
          end
        end
      end
    end

    actions.map do |action|
      action.to_hash["responses"].map do |response|
        response['tests'] ||= []
        response['tests'].map do |test|
          if response['combination'][0]
            response['combination'].map do |combination|
              begin
                res = JSON::Validator.fully_validate(combination['json_schema'], test['response']['body'])
                if res == []
                  combination['tests'].push(test)
                  response['tests'] = response['tests'] - [test]
                  next
                else
                  combination['error'].push({test: test, error: res})
                end
              rescue JSON::Schema::SchemaError => error
                combination['error'].push({test: test, error: error})
              end
            end
          end
        end
      end
    end

    actions_test = {actions: actions, tests: tests}

    makedirs('fitting')
    File.open('fitting/old_report.json', 'w') { |file| file.write(MultiJson.dump(actions_test)) }
  end

  # deprecated
  desc 'Fitting documentation'
  task :documentation do
    documented_unit = Fitting::Statistics::Template.new(
      Fitting::Records::Spherical::Requests.new,
      Fitting.configuration
    )
    puts documented_unit.stats

    unless documented_unit.not_covered == "\n"
      puts 'Not all responses from the whitelist are covered!'
      exit 1
    end
  end

  desc 'Fitting documentation responses cover'
  task :documentation_responses, [:size] => :environment do |_, args|
    if args.size == 'xs'
      documented_unit = Fitting::Statistics::Template.new(
        Fitting::Records::Spherical::Requests.new,
        Fitting.configuration
      )
      puts documented_unit.stats

      unless documented_unit.not_covered == "\n"
        puts 'Not all responses from the whitelist are covered!'
        exit 1
      end
    elsif args.size == 's'
      documented_unit = Fitting::Statistics::Template.new(
        Fitting::Records::Spherical::Requests.new,
        Fitting.configuration,
        'cover'
      )
      puts documented_unit.stats

      unless documented_unit.not_covered == "\n"
        puts 'Not all responses from the whitelist are covered!'
        exit 1
      end
    elsif args.size == 'm'
      documented_unit = Fitting::Statistics::Template.new(
        Fitting::Records::Spherical::Requests.new,
        Fitting.configuration,
        'cover_enum'
      )
      puts documented_unit.stats

      unless documented_unit.not_covered == "\n"
        puts 'Not all responses from the whitelist are covered!'
        exit 1
      end
    elsif args.size == 'l'
      documented_unit = Fitting::Statistics::Template.new(
        Fitting::Records::Spherical::Requests.new,
        Fitting.configuration,
        'cover_one_of'
      )
      puts documented_unit.stats

      unless documented_unit.not_covered == "\n"
        puts 'Not all responses from the whitelist are covered!'
        exit 1
      end
    else
      puts 'need key xs, s, m or l'
    end
  end

  desc 'Fitting documentation responses cover error'
  task :documentation_responses_error, [:size] => :environment do |_, args|
    if args.size == 's'
      documented_unit = Fitting::Statistics::TemplateCoverError.new(
        Fitting::Records::Spherical::Requests.new,
        Fitting.configuration
      )
      puts documented_unit.stats
    elsif args.size == 'm'
      documented_unit = Fitting::Statistics::TemplateCoverErrorEnum.new(
        Fitting::Records::Spherical::Requests.new,
        Fitting.configuration
      )
      puts documented_unit.stats
    elsif args.size == 'l'
      documented_unit = Fitting::Statistics::TemplateCoverErrorOneOf.new(
        Fitting::Records::Spherical::Requests.new,
        Fitting.configuration
      )
      puts documented_unit.stats
    else
      puts 'need key s, m or l'
    end
  end

  # deprecated
  desc 'Fitting tests'
  task :tests do
    realized_unit = Fitting::Records::RealizedUnit.new(
      Fitting::Records::Spherical::Requests.new,
      Fitting.configuration.tomogram
    )
    puts Fitting::Templates::RealizedTemplate.new(realized_unit).to_s

    unless realized_unit.fully_covered?
      puts 'Not all responses from the whitelist are covered!'
      exit 1
    end
  end

  desc 'Fitting tests'
  task :tests_responses, [:size] => :environment do |_, args|
    if args.size == 'xs'
      realized_unit = Fitting::Records::RealizedUnit.new(
        Fitting::Records::Spherical::Requests.new,
        Fitting.configuration.tomogram
      )
      puts Fitting::Templates::RealizedTemplate.new(realized_unit).to_s

      unless realized_unit.fully_covered?
        puts 'Not all responses from the whitelist are covered!'
        exit 1
      end
    else
      puts 'need key xs'
    end
  end
end
