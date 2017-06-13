require 'spec_helper'
require 'fitting/route/requests/statistics'

RSpec.describe Fitting::Route::Requests::Statistics do
  subject { described_class.new(requests) }

  let(:requests) { double }
  let(:size) { double }

  describe '.new' do
    it 'returns described class object' do
      expect(subject).to be_a(described_class)
    end
  end

  describe '#to_s' do
    before do
      allow(subject).to receive(:full_count).and_return('full_count')
      allow(subject).to receive(:full_percentage).and_return('full_percentage')
      allow(subject).to receive(:part_count).and_return('part_count')
      allow(subject).to receive(:part_percentage).and_return('part_percentage')
      allow(subject).to receive(:no_count).and_return('no_count')
      allow(subject).to receive(:no_percentage).and_return('no_percentage')
      allow(subject).to receive(:total_count).and_return('total_count')
    end

    it 'returns result in string' do
      expect(subject.to_s).to eq(
        "API requests with fully implemented responses: full_count (full_percentage% of total_count).\n"\
        "API requests with partially implemented responses: part_count (part_percentage% of total_count).\n"\
        'API requests with no implemented responses: no_count (no_percentage% of total_count).'
      )
    end
  end

  describe '#full_count' do
    let(:requests) { double(full_cover: double(size: size)) }

    it 'returns full cover count' do
      expect(subject.full_count).to eq(size)
    end
  end

  describe '#part_count' do
    let(:requests) { double(partial_cover: double(size: size)) }

    it 'returns part cover count' do
      expect(subject.part_count).to eq(size)
    end
  end

  describe '#no_count' do
    let(:requests) { double(no_cover: double(size: size)) }

    it 'returns no cover count' do
      expect(subject.no_count).to eq(size)
    end
  end

  describe '#total_count' do
    before do
      allow(subject).to receive(:full_count).and_return(1)
      allow(subject).to receive(:part_count).and_return(1)
      allow(subject).to receive(:no_count).and_return(1)
    end

    it 'returns sum' do
      expect(subject.total_count).to eq(3)
    end
  end

  describe '#full_percentage' do
    before do
      allow(subject).to receive(:full_count).and_return(1)
      allow(subject).to receive(:total_count).and_return(2)
    end

    it 'returns full cover percentage' do
      expect(subject.full_percentage).to eq(50.0)
    end

    context 'absent full cover' do
      before { allow(subject).to receive(:full_count).and_return(0) }

      it 'returns 0.0 percentage' do
        expect(subject.full_percentage).to eq(0.0)
      end

      context 'absent total cover' do
        before { allow(subject).to receive(:total_count).and_return(0) }

        it 'returns 0.0 percentage' do
          expect(subject.full_percentage).to eq(0.0)
        end
      end
    end
  end

  describe '#part_percentage' do
    before do
      allow(subject).to receive(:part_count).and_return(1)
      allow(subject).to receive(:total_count).and_return(2)
    end

    it 'returns part cover percentage' do
      expect(subject.part_percentage).to eq(50.0)
    end

    context 'absent part cover' do
      before { allow(subject).to receive(:part_count).and_return(0) }

      it 'returns 0.0 percentage' do
        expect(subject.part_percentage).to eq(0.0)
      end

      context 'absent total cover' do
        before { allow(subject).to receive(:total_count).and_return(0) }

        it 'returns 0.0 percentage' do
          expect(subject.part_percentage).to eq(0.0)
        end
      end
    end
  end

  describe '#no_percentage' do
    before do
      allow(subject).to receive(:no_count).and_return(1)
      allow(subject).to receive(:total_count).and_return(2)
    end

    it 'returns no cover percentage' do
      expect(subject.no_percentage).to eq(50.0)
    end

    context 'absent no cover' do
      before { allow(subject).to receive(:no_count).and_return(0) }

      it 'returns 0.0 percentage' do
        expect(subject.no_percentage).to eq(0.0)
      end

      context 'absent total cover' do
        before { allow(subject).to receive(:total_count).and_return(0) }

        it 'returns 0.0 percentage' do
          expect(subject.no_percentage).to eq(0.0)
        end
      end
    end
  end
end
