require 'fitting/statistics/template'
require 'fitting/statistics/test_template'

module Fitting
  class Statistics
    def initialize(tested_requests)
      @tested_requests = tested_requests
    end

    def save
      make_dir('fitting')
      if Fitting.configuration.is_a?(Array)
        Fitting.configuration.each do |config|
          make_dir("fitting/#{config.title}")
          Fitting::Statistics::Template.new(@tested_requests, config).save
        end
      else
        Fitting::Statistics::Template.new(@tested_requests, Fitting.configuration).save
        hash = @tested_requests.map { |request| request.to_spherical.to_hash }
        json = JSON.dump(hash)
        File.open("statistics.json", 'w') { |file| file.write(json) }
      end
    end

    def make_dir(dir_name)
      FileUtils.mkdir_p(dir_name)
    end
  end
end
