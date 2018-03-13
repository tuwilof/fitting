require 'fitting/statistics/template'

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
        array = @tested_requests.inject([]) do |res, request|
          next res unless request.path.to_s.start_with?(Fitting.configuration.prefix)
          res.push(request.to_spherical.to_hash)
        end
        json = JSON.dump(array)
        File.open("statistics.json", 'w') { |file| file.write(json) }
      end
    end

    def make_dir(dir_name)
      FileUtils.mkdir_p(dir_name)
    end
  end
end
