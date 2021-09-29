require 'fitting/statistics/template'

module Fitting
  class Tests
    def initialize(tested_requests)
      @tested_requests = tested_requests
    end

    def save
      make_dir('fitting_tests')
      array = @tested_requests.inject([]) do |res, request|
        res.push(request.to_spherical.to_hash)
      end
      json = JSON.dump(array)

      File.open("fitting_tests/test#{ENV['TEST_ENV_NUMBER']}.json", 'w') { |file| file.write(json) }
    end

    def make_dir(dir_name)
      FileUtils.mkdir_p(dir_name)
    end
  end
end
