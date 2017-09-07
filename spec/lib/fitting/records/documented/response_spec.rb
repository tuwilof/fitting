require 'spec_helper'
require 'fitting/records/documented/response'

RSpec.describe Fitting::Records::Documented::Response do
  subject { described_class.new(response) }

  let(:status) { double }
  let(:json_schemas) { double }
  let(:response) { { 'status' => status, 'json_schemas' => json_schemas } }

  describe '#status' do
    it 'returns status' do
      expect(subject.status).to eq(status)
    end
  end

  describe '#json_schemas' do
    it 'returns json_schemas' do
      expect(subject.json_schemas).to eq(json_schemas)
    end
  end
end
