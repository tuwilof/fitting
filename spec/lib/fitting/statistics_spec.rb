require 'spec_helper'

RSpec.describe Fitting::Statistics do
  describe '#to_s' do
    let(:response_routes) { double(white: nil) }
    let(:response_route_white) { nil }

    subject { described_class.new(response_routes, response_route_white) }

    before do
      allow(Fitting::Documentation::StatisticsWithConformityLists).to receive(:new)
        .and_return('statistics_with_conformity_lists')
    end

    it 'returns statistics' do
      expect(subject.to_s).to eq('statistics_with_conformity_lists')
    end

    context 'uses whitelist' do
      let(:response_routes) { double(white: nil, black: nil) }

      before do
        allow(Fitting.configuration).to receive(:white_list).and_return([])
        allow(Fitting::Documentation::Response::Route).to receive(:new)
        allow(Fitting::Documentation::Statistics).to receive(:new).and_return("statistics")
      end

      it 'returns two statistics' do
        expect(subject.to_s).to eq(
          ['[Black list]', 'statistics', '[White list]', 'statistics_with_conformity_lists'].join("\n")
        )
      end
    end
  end
end
