require 'spec_helper'
require 'fitting/records/tested/response'

RSpec.describe Fitting::Records::Tested::Response do
  subject { described_class.new(env_response) }

  describe '#status' do
    let(:status) { double }
    let(:env_response) { double(status: status) }

    it 'returns status' do
      expect(subject.status).to eq(status)
    end
  end

  describe '#body' do
    let(:body) { double }
    let(:env_response) { double(body: body) }

    it 'returns body' do
      expect(subject.body).to eq(body)
    end
  end
end
