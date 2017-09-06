require 'spec_helper'
require 'fitting/records/unit/request'

RSpec.describe Fitting::Records::Unit::Request do
  subject { described_class.new(documented_request, tested_requests) }

  describe '#path' do
    let(:path) { double }
    let(:documented_request) { double(path: path) }
    let(:tested_requests) { double }

    it 'returns path' do
      expect(subject.path).to eq(path)
    end
  end

  describe '#method' do
    let(:method) { double }
    let(:documented_request) { double(method: method) }
    let(:tested_requests) { double }

    it 'returns method' do
      expect(subject.method).to eq(method)
    end
  end

  describe '#responses' do
    let(:documented_request) { double(responses: double(to_a: [double])) }
    let(:tested_requests) { double }
    let(:response) { double }

    before do
      allow(subject).to receive(:tested_responses).and_return(double)
      allow(Fitting::Records::Unit::Response).to receive(:new).and_return(response)
    end

    it 'returns method' do
      expect(subject.responses).to eq([response])
    end
  end

  describe '#tested_responses' do
    let(:documented_request) { double(method: 200, path: double(match: true)) }
    let(:response) { double }
    let(:tested_request1) { double(method: 200, path: double(to_s: nil), responses: double(to_a: [response])) }
    let(:tested_request2) { double(method: 400, path: double(to_s: nil)) }
    let(:tested_requests) { double(to_a: [tested_request1, tested_request2]) }

    it 'returns tested_responses' do
      expect(subject.tested_responses).to eq([response])
    end
  end
end
