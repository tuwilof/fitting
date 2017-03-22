require 'spec_helper'

RSpec.describe Fitting::Statistics do
  let(:documentation) { double(black: black, white: white) }
  let(:all_responses) { nil }
  let(:strict) { nil }

  let(:white) { nil }
  let(:black) { nil }

  subject { described_class.new(documentation, all_responses, strict) }

  describe '#not_coverage?' do
    let(:white_route) { double(not_coverage: double(present?: true)) }

    before { allow(Fitting::Route).to receive(:new).with(all_responses, white, strict).and_return(white_route) }

    it 'return true' do
      expect(subject.not_coverage?).to be_truthy
    end
  end

  describe '#save' do
    let(:black) { double(any?: false) }
    let(:white_route) { double(statistics_with_conformity_lists: 'white_route statistics_with_conformity_lists') }
    let(:filename) { 'report.txt' }

    before do
      allow(Fitting::Route).to receive(:new).with(all_responses, white, strict).and_return(white_route)
      allow(Fitting::Route).to receive(:new).with(all_responses, black, strict).and_return(nil)
    end

    it 'no error' do
      expect { subject.save(filename) }.not_to raise_exception
      File.delete(filename)
    end
  end

  describe '#to_s' do
    let(:black) { double(any?: false) }
    let(:white_route) { double(statistics_with_conformity_lists: 'white_route statistics_with_conformity_lists') }

    before do
      allow(Fitting::Route).to receive(:new).with(all_responses, white, strict).and_return(white_route)
      allow(Fitting::Route).to receive(:new).with(all_responses, black, strict).and_return(nil)
    end

    it 'return statistics' do
      expect(subject.to_s).to eq("white_route statistics_with_conformity_lists\n\n")
    end

    context 'has black' do
      let(:black) { double(any?: true) }
      let(:black_route) { double(statistics_with_conformity_lists: 'black_route statistics_with_conformity_lists') }

      before { allow(Fitting::Route).to receive(:new).with(all_responses, black, strict).and_return(black_route) }

      it 'return statistics' do
        expect(subject.to_s).to eq(
          "[Black list]\nblack_route statistics_with_conformity_lists\n\n"\
          "[White list]\nwhite_route statistics_with_conformity_lists\n\n"
        )
      end
    end
  end
end
