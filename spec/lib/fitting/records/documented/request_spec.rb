require 'spec_helper'
require 'fitting/records/documented/request'

RSpec.describe Fitting::Records::Documented::Request do
  subject { described_class.new(tomogram_request) }

  let(:tomogram_request) { double }

  describe '#method' do
    let(:method) { double }
    let(:tomogram_request) { double(method: method) }

    it 'returns method' do
      expect(subject.method).to eq(method)
    end
  end

  describe '#path' do
    let(:path) { double }
    let(:tomogram_request) { double(path: path) }

    it 'returns method' do
      expect(subject.path).to eq(path)
    end
  end

  describe '#responses' do
    let(:json_schema1) { double }
    let(:json_schema2) { double }
    let(:json_schema3) { double }
    let(:tomogram_request) do
      double(responses: [{ 'status' => '200', 'body' => json_schema1 },
                         { 'status' => '200', 'body' => json_schema2 },
                         { 'status' => '400', 'body' => json_schema3 }])
    end

    it 'returns responses' do
      expect(subject.responses).to eq(
        [
          { 'status' => '200', 'json_schemas' => [json_schema1, json_schema2] },
          { 'status' => '400', 'json_schemas' => [json_schema3] }
        ]
      )
    end
  end
end
