require 'spec_helper'
require 'fitting/records/unit/response'

RSpec.describe Fitting::Records::Unit::Response do
  subject { described_class.new(documented_response, tested_responses) }

  describe '#status' do
    let(:status) { double }
    let(:documented_response) { { 'status' => status } }
    let(:tested_responses) { double }

    it 'returns status' do
      expect(subject.status).to eq(status)
    end
  end

  describe '#json_schemas' do
    let(:status) { double }
    let(:documented_response) { { 'json_schemas' => [double] } }
    let(:tested_responses) { double }
    let(:json_schema) { double }

    before do
      allow(subject).to receive(:tested_bodies).and_return(double)
      allow(Fitting::Records::Unit::JsonSchema).to receive(:new).and_return(json_schema)
    end

    it 'returns json_schemas' do
      expect(subject.json_schemas).to eq([json_schema])
    end
  end

  describe '#tested_bodies' do
    let(:documented_response) { { 'status' => '200' } }
    let(:body1) { double }
    let(:body2) { double }
    let(:body3) { double }
    let(:tested_responses) do
      [
        double(status: 200, body: body1),
        double(status: 200, body: body2),
        double(status: 400, body: body3)
      ]
    end

    it 'returns tested_bodies' do
      expect(subject.tested_bodies).to eq([body1, body2])
    end
  end
end
