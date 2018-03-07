require 'spec_helper'
require 'fitting/records/spherical/response'

RSpec.describe Fitting::Records::Spherical::Response do
  describe '#dump' do
    subject { described_class.new(status: 200, body: "{\"name\": \"noname\"}") }
    let(:json) { "{\"status\":200,\"body\":\"{\\\"name\\\": \\\"noname\\\"}\"}" }

    it 'returns json' do
      expect(subject.dump).to eq(json)
    end
  end

  describe '#load' do
    subject { described_class.load(json) }
    let(:json) { "{\"status\":200,\"body\":\"{\\\"name\\\": \\\"noname\\\"}\"}" }

    it 'returns status' do
      expect(subject.status).to eq(200)
    end

    it 'returns body' do
      expect(subject.body).to eq("{\"name\": \"noname\"}")
    end
  end
end
