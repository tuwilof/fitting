require 'spec_helper'
require 'fitting/configuration/yaml'

RSpec.describe Fitting::Configuration::Yaml do
  subject { described_class.new(yaml) }

  let(:yaml) { {} }

  describe '#tomogram' do
    before { allow(Tomograph::Tomogram).to receive(:new) }

    it 'does not raise expection' do
      expect { subject.tomogram }.not_to raise_exception
    end
  end

  describe '#stats_path' do
    it 'returns default' do
      expect(subject.stats_path).to eq('fitting/stats')
    end

    context 'has title' do
      subject { described_class.new(yaml, 'title') }

      it 'returns with title' do
        expect(subject.stats_path).to eq('fitting/title/stats')
      end
    end
  end

  describe '#not_covered_path' do
    it 'returns default' do
      expect(subject.not_covered_path).to eq('fitting/not_covered')
    end

    context 'has title' do
      subject { described_class.new(yaml, 'title') }

      it 'returns with title' do
        expect(subject.not_covered_path).to eq('fitting/title/not_covered')
      end
    end
  end
end
