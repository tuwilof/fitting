require 'fitting/records/spherical/requests'
require 'fitting/configuration'
require 'fitting/records/realized_unit'
require 'fitting/templates/realized_template'

namespace :fitting do
  desc 'Fitting documentation'
  task :documentation do
    puts `bundle exec rspec ./spec/controllers`
    puts `cat fitting/stats`

    result = File.read('fitting/not_covered')
    unless result == "\n"
      puts 'Not all responses from the whitelist are covered!'
      exit 1
    end
  end

  desc 'Fitting realization'
  task :realization do
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
