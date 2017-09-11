require 'spec_helper'
require 'fitting/statistics/lists'

RSpec.describe Fitting::Statistics::Lists do
  subject { described_class.new(measurement) }

  let(:measurement) { double }

  describe '#coverage_fully_stat' do
    let(:measurement) { double(coverage_fully: []) }

    it 'returns nil' do
      expect(subject.coverage_fully_stat).to be_nil
    end

    context 'coverage fully is not empty' do
      let(:measurement) { double(coverage_fully: [double], max_response_path: nil) }

      before { allow(Fitting::Statistics::List).to receive(:new).and_return(double(to_s: 'list')) }

      it 'return coverage fully stat string' do
        expect(subject.coverage_fully_stat).to eq("Fully conforming requests:\nlist")
      end
    end
  end

  describe '#coverage_partially_stat' do
    let(:measurement) { double(coverage_partially: []) }

    it 'returns nil' do
      expect(subject.coverage_partially_stat).to be_nil
    end

    context 'coverage partially is not empty' do
      let(:measurement) { double(coverage_partially: [double], max_response_path: nil) }

      before { allow(Fitting::Statistics::List).to receive(:new).and_return(double(to_s: 'list')) }

      it 'return coverage partially stat string' do
        expect(subject.coverage_partially_stat).to eq("Partially conforming requests:\nlist")
      end
    end
  end

  describe '#coverage_non_stat' do
    let(:measurement) { double(coverage_non: []) }

    it 'returns nil' do
      expect(subject.coverage_non_stat).to be_nil
    end

    context 'coverage non is not empty' do
      let(:measurement) { double(coverage_non: [double], max_response_path: nil) }

      before { allow(Fitting::Statistics::List).to receive(:new).and_return(double(to_s: 'list')) }

      it 'return coverage non stat string' do
        expect(subject.coverage_non_stat).to eq("Non-conforming requests:\nlist")
      end
    end
  end

  describe '#to_s' do
    before do
      allow(subject).to receive(:coverage_fully_stat).and_return('coverage_fully_stat')
      allow(subject).to receive(:coverage_partially_stat).and_return('coverage_partially_stat')
      allow(subject).to receive(:coverage_non_stat).and_return('coverage_non_stat')
    end

    it 'returns lists string' do
      expect(subject.to_s).to eq("coverage_fully_stat\n\ncoverage_partially_stat\n\ncoverage_non_stat")
    end
  end
end
