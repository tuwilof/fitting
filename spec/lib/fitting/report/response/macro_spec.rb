require 'spec_helper'
require 'fitting/report/response/macro'
require 'multi_json'

RSpec.describe Fitting::Report::Response::Macro do
  describe '.new' do
    it do
      described_class.new(
        {
          'location1' => {
            'request' => MultiJson.dump({}),
            'response' => MultiJson.dump({})
          },
          'location2' => {
            'request' => MultiJson.dump({'schema' => {}}),
            'response' => MultiJson.dump({})
          },
          'location3' => {
            'request' => MultiJson.dump({'schema' => {}}),
            'response' => MultiJson.dump({'schemas' => {}})
          }
        }
      )
    end
  end

  describe '#responses_documented' do
    it do
      described_class.new({}).responses_documented(nil, true, {'valid' => {}, 'invalid' => {}}, nil)
    end
  end

  describe '#push' do
    it do
      described_class.new({}).push('key', {'key' => {'name' => []}}, 'name', 'location')
    end
  end

  describe '#to_hash' do
    it do
      described_class.new({}).to_hash
    end
  end
end
