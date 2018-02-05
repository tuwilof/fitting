require 'spec_helper'
require 'fitting/statistics/template'

RSpec.describe Fitting::Statistics::Template do
  subject { described_class.new(tested_requests, config) }

  let(:tested_requests) { double }
  let(:config) { double }

  describe '#save' do
    let(:config) do
      double(
        stats_path: 'stats',
        not_covered_path: 'not_covered'
      )
    end

    before do
      allow(subject).to receive(:stats).and_return('')
      allow(subject).to receive(:not_covered).and_return('')
    end

    it 'no error' do
      expect { subject.save }.not_to raise_exception
      FileUtils.rm_r 'stats'
      FileUtils.rm_r 'not_covered'
    end
  end

  describe '#stats' do
    context 'all requests are less than white' do
      let(:config) do
        double(
          white_list: double(present?: false),
          resource_white_list: double(present?: false),
          include_resources: double(present?: false)
        )
      end

      before do
        allow(subject).to receive(:documented).and_return(double(to_a: double(size: 0)))
        allow(subject).to receive(:documented_requests_white).and_return(double(size: 1))
        allow(subject).to receive(:white_statistics).and_return('white_statistics')
      end

      it 'returns white_statistics' do
        expect(subject.stats).to eq("white_statistics\n\n")
      end
    end

    context 'all requests are more than white' do
      let(:config) do
        double(
          white_list: double(present?: true)
        )
      end

      before do
        allow(subject).to receive(:documented).and_return(double(to_a: double(size: 1)))
        allow(subject).to receive(:documented_requests_white).and_return(double(size: 0))
        allow(subject).to receive(:white_statistics).and_return('white_statistics')
        allow(subject).to receive(:black_statistics).and_return('black_statistics')
      end

      it 'returns white_statistics' do
        expect(subject.stats).to eq("[Black list]\nblack_statistics\n\n[White list]\nwhite_statistics\n\n")
      end
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

  describe '#white_statistics' do
    before do
      allow(subject).to receive(:white_measurement)
      allow(Fitting::Statistics::Analysis).to receive(:new)
    end

    it 'does not raise an error' do
      expect { subject.white_statistics }.not_to raise_exception
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

  describe '#white_measurement' do
    before do
      allow(subject).to receive(:white_unit)
      allow(Fitting::Statistics::Measurement).to receive(:new)
    end

    it 'does not raise an error' do
      expect { subject.white_measurement }.not_to raise_exception
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

  describe '#white_unit' do
    before do
      allow(subject).to receive(:documented_requests_white).and_return([double])
      allow(Fitting::Records::Unit::Request).to receive(:new)
    end

    it 'does not raise an error' do
      expect { subject.white_unit }.not_to raise_exception
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

  describe '#documented_requests_white' do
    let(:documented_requests) do
      [
        request,
        double(white: false)
      ]
    end
    let(:request) { double(white: true) }

    before { allow(subject).to receive(:documented).and_return(documented_requests) }

    it 'returns documented_requests_white' do
      expect(subject.documented_requests_white).to eq([request])
    end
  end

  describe '#documented_requests_black' do
    let(:documented_requests) do
      [
        request,
        double(white: true)
      ]
    end
    let(:request) { double(white: false) }

    before { allow(subject).to receive(:documented).and_return(documented_requests) }

    it 'returns documented_requests_black' do
      expect(subject.documented_requests_black).to eq([request])
    end
  end

  describe '#documented' do
    let(:config) { double(tomogram: double(to_hash: [double])) }

    before do
      allow(Fitting::Records::Documented::Request).to receive(:new)
      allow(subject).to receive(:white_list).and_return(double(to_a: nil))
    end

    it 'does not raise an error' do
      expect { subject.documented }.not_to raise_exception
    end
  end

  describe '#white_list' do
    let(:config) do
      double(
        white_list: nil,
        resource_white_list: nil,
        tomogram: double(to_resources: nil),
        prefix: nil,
        include_resources: nil,
        include_actions: nil
      )
    end

    before { allow(Fitting::Storage::WhiteList).to receive(:new) }

    it 'does not raise an error' do
      expect { subject.white_list }.not_to raise_exception
    end
  end
end
