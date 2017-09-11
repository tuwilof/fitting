require 'spec_helper'
require 'fitting/statistics'

RSpec.describe Fitting::Statistics do
  subject { described_class.new(documented_requests, tested_requests) }

  let(:documented_requests) { double }
  let(:tested_requests) { double }

  describe '#documented_requests_black' do
    let(:documented_requests) do
      [
        request,
        double(white: true)
      ]
    end
    let(:request) { double(white: false) }

    it 'returns documented_requests_black' do
      expect(subject.documented_requests_black).to eq([request])
    end
  end

  describe '#documented_requests_white' do
    let(:documented_requests) do
      [
        request,
        double(white: false)
      ]
    end
    let(:request) { double(white: true) }

    it 'returns documented_requests_white' do
      expect(subject.documented_requests_white).to eq([request])
    end
  end

  describe '#black_unit' do
    before do
      allow(subject).to receive(:documented_requests_black).and_return([double])
      allow(Fitting::Records::Unit::Request).to receive(:new)
    end

    it 'does not raise an error' do
      expect { subject.black_unit }.not_to raise_exception
    end
  end

  describe '#white_unit' do
    before do
      allow(subject).to receive(:documented_requests_white).and_return([double])
      allow(Fitting::Records::Unit::Request).to receive(:new)
    end

    it 'does not raise an error' do
      expect { subject.white_unit }.not_to raise_exception
    end
  end

  describe '#black_measurement' do
    before do
      allow(subject).to receive(:black_unit)
      allow(Fitting::Statistics::Measurement).to receive(:new)
    end

    it 'does not raise an error' do
      expect { subject.black_measurement }.not_to raise_exception
    end
  end

  describe '#white_measurement' do
    before do
      allow(subject).to receive(:white_unit)
      allow(Fitting::Statistics::Measurement).to receive(:new)
    end

    it 'does not raise an error' do
      expect { subject.white_measurement }.not_to raise_exception
    end
  end

  describe '#black_statistics' do
    before do
      allow(subject).to receive(:black_measurement)
      allow(Fitting::Statistics::Analysis).to receive(:new)
    end

    it 'does not raise an error' do
      expect { subject.black_statistics }.not_to raise_exception
    end
  end

  describe '#white_statistics' do
    before do
      allow(subject).to receive(:white_measurement)
      allow(Fitting::Statistics::Analysis).to receive(:new)
    end

    it 'does not raise an error' do
      expect { subject.white_statistics }.not_to raise_exception
    end
  end

  describe '#not_covered' do
    before do
      allow(subject).to receive(:white_measurement)
      allow(Fitting::Statistics::NotCoveredResponses).to receive(:new).and_return(double(to_s: nil))
    end

    it 'does not raise an error' do
      expect { subject.not_covered }.not_to raise_exception
    end
  end

  describe '#stats' do
    context 'all requests are less than white' do
      let(:documented_requests) { double(to_a: double(size: 0)) }

      before do
        allow(subject).to receive(:documented_requests_white).and_return(double(size: 1))
        allow(subject).to receive(:white_statistics).and_return('white_statistics')
      end

      it 'returns white_statistics' do
        expect(subject.stats).to eq("white_statistics\n\n")
      end
    end

    context 'all requests are more than white' do
      let(:documented_requests) { double(to_a: double(size: 1)) }

      before do
        allow(subject).to receive(:documented_requests_white).and_return(double(size: 0))
        allow(subject).to receive(:white_statistics).and_return('white_statistics')
        allow(subject).to receive(:black_statistics).and_return('black_statistics')
      end

      it 'returns white_statistics' do
        expect(subject.stats).to eq("[Black list]\nblack_statistics\n\n[White list]\nwhite_statistics\n\n")
      end
    end
  end

  describe '#save' do
    before do
      allow(subject).to receive(:stats).and_return('stats')
      allow(subject).to receive(:not_covered).and_return('not_covered')
    end

    it 'no error' do
      expect { subject.save }.not_to raise_exception
      FileUtils.rm_r 'fitting'
    end
  end
end
