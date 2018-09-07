require 'fitting/statistics/template'

module Fitting
  class Tests
    def initialize(tested_requests)
      @tested_requests = tested_requests
    end

    def save
      array = @tested_requests.inject([]) do |res, request|
        next res unless request.path.to_s.start_with?(Fitting.configuration.prefix)
        res.push(request.to_spherical.to_hash)
      end
      json = JSON.dump(array)
      File.open('tests.json', 'w') { |file| file.write(json) }
    end

    def make_dir(dir_name)
      FileUtils.mkdir_p(dir_name)
    end
  end
end
