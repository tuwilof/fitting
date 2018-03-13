require 'fitting/records/spherical/request'
require 'fitting/statistics/test_template'
require 'fitting/configuration'

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

  desc 'Fitting tests'
  task :tests do
    array = JSON.load(File.read('statistics.json'))
    spherical_requests = array.inject([]) do |res, tested_request|
      res.push(Fitting::Records::Spherical::Request.load(tested_request))
    end

    result = Fitting::Statistics::TestTemplate.new(spherical_requests, Fitting.configuration).check
    unless result == "\n"
      puts 'Not all responses from the whitelist are covered!'
      exit 1
    end
  end
end
