require 'tomogram_routing'
require 'json-schema'
require 'fitting/storage/yaml_file'
require 'fitting/request'
require 'fitting/response'

module Fitting
  class Documentation
    class << self
      def try_on(date, env_request, env_response)
        request = Request.new(env_request, tomogram)
        request.valid! if request.validate?
        response = Response.new(env_response, request.schema)
        response.valid! if response.validate?
        add_storage(location(date), request, response)
      end

      def response_valid?(env_request, env_response)
        request = Request.new(env_request, tomogram)
        request.valid! if request.validate?
        response = Response.new(env_response, request.schema)
        response.to_hash
      end

      private

      def add_storage(location, request, response)
        Fitting::Storage::YamlFile.push(
          location,
          'request' => MultiJson.dump(request.to_hash),
          'response' => MultiJson.dump(response.to_hash)
        )
      end

      def tomogram
        @tomogram ||= TomogramRouting::Tomogram.craft(Fitting.configuration.tomogram)
      end

      def location(date)
        name = date.inspect.to_s
        if name.split('(').size > 1
          name.split('(').last.split(')').first[2..-1]
        else
          name.split(' ')[3][2..-3]
        end
      end
    end
  end
end

RSpec::Matchers.define :be_a_multiple_of do |expected|
  match do |actual|
    actual["valid"] == true
  end
  failure_message do |actual|
    fvs = ""
    actual["fully_validates"].map{|fv| fvs += "#{fv}\n"}
    shcs = ""
    actual["schemas"].map{|shc| shcs += "#{shc}\n"}
    "response not valid json-schema\n"\
    "got: #{actual["body"]}\n"\
    "diff: \n#{fvs}"\
    "expected: \n#{shcs}\n"
  end
end

RSpec.configure do |config|
  config.after(:each, :type => :controller) do
    response.body = MultiJson.dump(CamelCase.hash(MultiJson.load(response.body)))
    valid = Fitting::Documentation.response_valid?(request, response)
    expect(valid).to be_a_multiple_of
  end
end
