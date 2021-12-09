require 'fitting/version'
require 'fitting/configuration'

require 'fitting/storage/responses'
require 'fitting/tests'
require 'fitting/cover/json_schema_enum'
require 'fitting/cover/json_schema_one_of'
require 'fitting/records/documented/request'
require 'fitting/railtie' if defined?(Rails)

module Fitting
  class << self
    def configuration
      yaml = YAML.safe_load(File.read('.fitting.yml'))
      @configuration ||= Configuration.new(yaml)
    end

    def configure
      yield(configuration)
    end

    def clear_tests_directory
      FileUtils.rm_r Dir.glob(configuration.rspec_json_path), force: true
      FileUtils.rm_r Dir.glob(configuration.webmock_json_path), force: true
    end

    def save_test_data
      clear_tests_directory

      outgoing_responses = Fitting::Storage::Responses.new
      responses = Fitting::Storage::Responses.new

      RSpec.configure do |config|
        if defined?(WebMock)
          config.before(:each) do |example|
            WebMock.after_request do |request_signature, response|
              env = Rack::MockRequest.env_for(request_signature.uri, { method: request_signature.method })
              # Парсим в тот формат с которым работает fitting
              mock_request = ActionDispatch::Request.new(env)
              mock_response = ActionDispatch::Response.create(response.status.first || 200, response.headers || {},
                                                              response.body || {})
              mock_response.instance_variable_set(:@request, mock_request)

              outgoing_responses.add(mock_response, example)
            end
          end
        end

        config.after(:each, type: :request) do |example|
          responses.add(response, example)
        end

        config.after(:each, type: :controller) do |example|
          responses.add(response, example)
        end

        config.after(:each) do
          WebMock::CallbackRegistry.reset
        end

        config.after(:suite) do
          responses.tests.save
          outgoing_responses.tests.outgoing_save
        end
      end
    end
  end
end
