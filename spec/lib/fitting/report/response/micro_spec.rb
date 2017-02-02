require 'spec_helper'
require 'fitting/report/response/micro'
require 'multi_json'

RSpec.describe Fitting::Report::Response::Micro do
  describe '.new' do
    it 'not raise exception' do
      expect do
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
              'response' => MultiJson.dump({'schemas' => {}, 'fully_validates' => {}})
            }
          }
        )
      end.not_to raise_exception
    end
  end

  describe '#responses_documented' do
    it 'not raise exception' do
      response = {
        'schemas' => [
          {
            'fully_validate' => {},
            'body' => {}
          }
        ],
        'fully_validates' => {}
      }
      expect do
        described_class.new({}).responses_documented('location', {}, response)
      end.not_to raise_exception
    end

    it 'not raise exception' do
      response = {
        'valid' => true,
        'schemas' => [
          {
            'fully_validate' => {},
            'body' => {}
          }
        ],
        'fully_validates' => {}
      }
      expect do
        described_class.new({}).responses_documented('location', {}, response)
      end.not_to raise_exception
    end
  end

  describe '#to_hash' do
    it 'not raise exception' do
      expect do
        described_class.new({}).to_hash
      end.not_to raise_exception
    end
  end
end
