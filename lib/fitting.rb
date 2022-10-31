require 'json-schema'
require 'fitting/version'
require 'fitting/cover/json_schema_enum'
require 'fitting/cover/json_schema_one_of'
require 'fitting/records/documented/request'
require 'fitting/railtie' if defined?(Rails)
require 'fitting/records/tested/request'

module Fitting
  class << self
    def logger
      # :nocov:
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

              request = Fitting::Records::Tested::Request.new(mock_response, example)
              Rails.logger.debug "FITTING outgoing request #{request.to_spherical.to_json}"
            end
          end
        end

        config.after(:each, type: :request) do |example|
          request = Fitting::Records::Tested::Request.new(response, example)
          Rails.logger.debug "FITTING incoming request #{request.to_spherical.to_json}"
        end

        config.after(:each, type: :controller) do |example|
          request = Fitting::Records::Tested::Request.new(response, example)
          Rails.logger.debug "FITTING incoming request #{request.to_spherical.to_json}"
        end

        config.after(:each) do
          WebMock::CallbackRegistry.reset
        end

        config.before(:each, type: :request) do
          host! YAML.safe_load(File.read('.fitting.yml'))['Host']
        end
      end
      # :nocov:
    end
  end
end

module ActionDispatch
  class TestRequest
    # Override host, by default it is test.host
    def host
      YAML.safe_load(File.read('.fitting.yml'))['Host']
    end
  end
end
