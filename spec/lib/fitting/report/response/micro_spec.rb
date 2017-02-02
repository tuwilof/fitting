require 'spec_helper'
require 'fitting/report/response/micro'
require 'multi_json'

RSpec.describe Fitting::Report::Response::Micro do
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
      response = {
        'schemas' => [
          {
            'fully_validate' => {},
            'body' => {}
          }
        ]
      }
      described_class.new({}).responses_documented('location', {}, response)
    end

    it do
      response = {
        'valid' => true,
        'schemas' => [
          {
            'fully_validate' => {},
            'body' => {}
          }
        ]
      }
      described_class.new({}).responses_documented('location', {}, response)
    end
  end

  describe '#to_hash' do
    it do
      described_class.new({}).to_hash
    end
  end
end
