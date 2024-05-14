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
      responses = ""
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
              responses += "FITTING outgoing request #{request.to_spherical.to_json}\n"
            end
          end
        end

        config.after(:each, type: :request) do |example|
          begin
            request = Fitting::Records::Tested::Request.new(response, example)
            responses += "FITTING incoming request #{request.to_spherical.to_json}\n"
          rescue NoMethodError
          end
        end

        config.after(:each, type: :controller) do |example|
          begin
            request = Fitting::Records::Tested::Request.new(response, example)
            responses += "FITTING incoming request #{request.to_spherical.to_json}\n"
          rescue NoMethodError
          end
        end

        config.after(:each) do
          WebMock::CallbackRegistry.reset if Object.const_defined?('WebMock')
        end

        config.after(:suite) do
          File.open("log/fitting#{ENV['TEST_ENV_NUMBER']}.log", 'w') { |file| file.write(responses) }
        end
      end
      # :nocov:
    end
  end
end
