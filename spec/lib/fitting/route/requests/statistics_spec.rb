require 'spec_helper'
require 'fitting/route/requests/statistics'

RSpec.describe Fitting::Route::Requests::Statistics do
  subject { described_class.new(full_count, part_count, no_count) }

  let(:full_count) { double }
  let(:part_count) { double }
  let(:no_count) { double }

  describe '.new' do
    it 'returns described class object' do
      expect(subject).to be_a(described_class)
    end
  end

  describe '#to_s' do
    before do
      allow(subject).to receive(:full_percent).and_return('full_percent')
      allow(subject).to receive(:part_percent).and_return('part_percent')
      allow(subject).to receive(:no_percent).and_return('no_percent')
      allow(subject).to receive(:total_count).and_return('total_count')
    end

    let(:full_count) { 'full_count' }
    let(:part_count) { 'part_count' }
    let(:no_count) { 'no_count' }

    it 'returns result in string' do
      expect(subject.to_s).to eq(
        "API requests with fully implemented responses: full_count (full_percent% of total_count).\n"\
        "API requests with partially implemented responses: part_count (part_percent% of total_count).\n"\
        'API requests with no implemented responses: no_count (no_percent% of total_count).'
      )
    end
  end

  describe '#total_count' do
    let(:full_count) { 1 }
    let(:part_count) { 1 }
    let(:no_count) { 1 }

    it 'returns sum' do
      expect(subject.total_count).to eq(3)
    end
  end

  describe '#full_percent' do
    let(:full_count) { 1 }

    before do
      allow(subject).to receive(:total_count).and_return(2)
    end

    it 'returns full cover percent' do
      expect(subject.full_percent).to eq(50.0)
    end

    context 'absent full cover' do
      let(:full_count) { 0 }

      it 'returns 0.0 percent' do
        expect(subject.full_percent).to eq(0.0)
      end

      context 'absent total cover' do
        before { allow(subject).to receive(:total_count).and_return(0) }

        it 'returns 0.0 percent' do
          expect(subject.full_percent).to eq(0.0)
        end
      end
    end
  end

  describe '#part_percent' do
    let(:part_count) { 1 }

    before do
      allow(subject).to receive(:total_count).and_return(2)
    end

    it 'returns part cover percent' do
      expect(subject.part_percent).to eq(50.0)
    end

    context 'absent part cover' do
      let(:part_count) { 0 }

      it 'returns 0.0 percent' do
        expect(subject.part_percent).to eq(0.0)
      end

      context 'absent total cover' do
        before { allow(subject).to receive(:total_count).and_return(0) }

        it 'returns 0.0 percent' do
          expect(subject.part_percent).to eq(0.0)
        end
      end
    end
  end

  describe '#no_percent' do
    let(:no_count) { 1 }

    before do
      allow(subject).to receive(:total_count).and_return(2)
    end

    it 'returns no cover percent' do
      expect(subject.no_percent).to eq(50.0)
    end

    context 'absent no cover' do
      let(:no_count) { 0 }

      it 'returns 0.0 percent' do
        expect(subject.no_percent).to eq(0.0)
      end

      context 'absent total cover' do
        before { allow(subject).to receive(:total_count).and_return(0) }

        it 'returns 0.0 percent' do
          expect(subject.no_percent).to eq(0.0)
        end
      end
    end
  end
end
