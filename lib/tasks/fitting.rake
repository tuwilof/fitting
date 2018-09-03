require 'fitting/records/spherical/requests'
require 'fitting/configuration'
require 'fitting/records/realized_unit'
require 'fitting/templates/realized_template'
require 'fitting/statistics/template_cover_error'

namespace :fitting do
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

  desc 'Fitting documentation response cover'
  task :documentation_response, [:size] => :environment do |_, args|
    if  args.size == 'xs'
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
    else
      puts 'need key xs or s'
    end
  end

  desc 'Fitting documentation response cover error'
  task :documentation_response_error, [:size] => :environment do |_, args|
    if args.size == 's'
      documented_unit = Fitting::Statistics::TemplateCoverError.new(
        Fitting::Records::Spherical::Requests.new,
        Fitting.configuration
      )
      puts documented_unit.stats
    else
      puts 'need key s'
    end
  end

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
end
