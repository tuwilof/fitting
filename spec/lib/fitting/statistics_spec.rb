require 'spec_helper'

RSpec.describe Fitting::Statistics do
  describe '#to_s' do
    let(:response) { double(
      routes: double(white: nil, black: nil),
      monochrome_route: double(white: nil, black: nil)
    ) }

    subject { described_class.new(response) }

    before do
      allow(Fitting::Documentation::StatisticsWithConformityLists).to receive(:new)
        .and_return('statistics_with_conformity_lists')
    end

    it 'returns statistics' do
      expect(subject.to_s).to eq("statistics_with_conformity_lists\n\n")
    end

    context 'uses whitelist' do
      before do
        allow(Fitting.configuration).to receive(:white_list).and_return([])
        allow(Fitting::Documentation::Response::MonochromeRoute::Route).to receive(:new)
        allow(Fitting::Documentation::Statistics).to receive(:new).and_return("statistics")
      end

      it 'returns two statistics' do
        expect(subject.to_s).to eq(
          [
            ['[Black list]', 'statistics'].join("\n"),
            ['[White list]', 'statistics_with_conformity_lists'].join("\n"),
            ""
          ].join("\n\n")
        )
      end
    end
  end
end
