require 'spec_helper'
require 'fitting/records/spherical/response'

RSpec.describe Fitting::Records::Spherical::Response do
  let(:json) { "{\"status\":200,\"body\":{\"name\":\"noname\"}}" }
  let(:body) { "{\"name\": \"noname\"}" }

  describe '#to_json' do
    subject { described_class.new(status: 200, body: body) }

    it 'returns json' do
      expect(subject.to_json).to eq(json)
    end
  end

  describe '#to_hash' do
    subject { described_class.new(status: 200, body: body) }

    it 'returns json' do
      expect(subject.to_hash).to eq({:status => 200, :body => {"name" => "noname"}})
    end
  end

  describe '#load' do
    subject { described_class.load(json) }

    it 'returns status' do
      expect(subject.status).to eq(200)
    end

    it 'returns body' do
      expect(subject.body).to eq({"name"=>"noname"})
    end
  end
end
