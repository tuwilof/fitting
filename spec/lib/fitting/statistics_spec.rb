require 'spec_helper'

RSpec.describe Fitting::Statistics do
  describe '#to_s' do
    let(:response_routes) { double(white: nil) }
    let(:response_route_white) { nil }

    subject { described_class.new(response_routes, response_route_white) }

    before do
      allow(Fitting::Documentation::StatisticsWithConformityLists).to receive(:new).and_return(nil)
    end

    it 'returns statistics' do
      expect(subject.to_s).to eq('')
    end
  end
end
