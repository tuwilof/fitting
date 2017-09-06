require 'spec_helper'
require 'fitting/records/unit'

RSpec.describe Fitting::Records::Unit do
  subject { described_class.new(documented_requests, tested_requests) }

  describe '#requests' do
    let(:documented_requests) { [double] }
    let(:tested_requests) { double }
    let(:request) { double }

    before do
      allow(Fitting::Records::Unit::Request).to receive(:new).and_return(request)
    end

    it 'returns requests' do
      expect(subject.requests).to eq([request])
    end
  end
end
