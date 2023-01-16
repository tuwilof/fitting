require 'spec_helper'
require 'fitting/records/spherical/response'

RSpec.describe Fitting::Records::Spherical::Response do
  describe '#to_json' do
    subject { described_class.new(status: 200, body: '{"name": "noname"}') }

    it 'returns json' do
      expect(subject.to_json).to eq('{"status":200,"content_type":"application/json","body":{"name":"noname"}}')
    end
  end

  describe '#to_hash' do
    subject { described_class.new(status: 200, body: '{"name": "noname"}') }

    it 'returns hash' do
      expect(subject.to_hash).to eq(status: 200, "content_type": "application/json", body: { 'name' => 'noname' })
    end
  end

  describe '#load' do
    subject { described_class.load('status' => 200, 'body' => { 'name' => 'noname' }) }

    it 'returns status' do
      expect(subject.status).to eq(200)
    end

    it 'returns body' do
      expect(subject.body).to eq('name' => 'noname')
    end
  end
end
