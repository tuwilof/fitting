module Fitting
  class Tests
    def initialize(tested_requests)
      @tested_requests = tested_requests
    end

    def save
      make_dir(Fitting.configuration.rspec_json_path)
      array = @tested_requests.inject([]) do |res, request|
        Rails.logger.debug "FITTING incoming request🚧#{request.to_spherical.to_json}"
        res.push(request.to_spherical.to_hash)
      end
      json = JSON.dump(array)

      File.open("#{Fitting.configuration.rspec_json_path}/test#{ENV['TEST_ENV_NUMBER']}.json", 'w') { |file| file.write(json) }
    end

    def outgoing_save
      make_dir('./outgoing_request_tests')
      array = @tested_requests.inject([]) do |res, request|
        Rails.logger.debug "FITTING outgoing request🚧#{request.to_spherical.to_json}"
        res.push(request.to_spherical.to_hash)
      end
      json = JSON.dump(array)

      File.open("./outgoing_request_tests/test#{ENV['TEST_ENV_NUMBER']}.json", 'w') { |file| file.write(json) }
    end

    def make_dir(dir_name)
      FileUtils.mkdir_p(dir_name)
    end
  end
end
