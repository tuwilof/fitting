require 'spec_helper'
require 'fitting/report/response/macro'
require 'multi_json'

RSpec.describe Fitting::Report::LegacyResponse::Macro do
  let(:tomogram) { MultiJson.dump([]) }
  before do
    allow(Fitting).to receive(:configuration).and_return(
      double(
        tomogram: tomogram
      )
    )
  end

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
              'response' => MultiJson.dump({'schemas' => {}})
            }
          }
        )
      end.not_to raise_exception
    end
  end

  describe '#responses_documented' do
    it 'not raise exception' do
      expect do
        described_class.new({}).responses_documented(nil, true, {'valid' => {}, 'invalid' => {}}, nil, {}, {'schemas'=>{}})
      end.not_to raise_exception
    end
  end

  describe '#push' do
    it 'not raise exception' do
      expect do
        described_class.new({}).push('key', {'key' => {'name' => []}}, 'name', 'location')
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
