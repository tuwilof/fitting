require 'spec_helper'
require 'fitting/configuration/legacy'

RSpec.describe Fitting::Configuration::Legacy do
  describe '#tomogram' do
    before { allow(Tomograph::Tomogram).to receive(:new) }

    it 'does not raise expection' do
      expect { subject.tomogram }.not_to raise_exception
    end
  end

  describe '#title' do
    it 'returns default' do
      expect(subject.title).to eq('fitting')
    end
  end

  describe '#stats_path' do
    it 'returns default' do
      expect(subject.stats_path).to eq('fitting/stats')
    end
  end

  describe '#not_covered_path' do
    it 'returns default' do
      expect(subject.not_covered_path).to eq('fitting/not_covered')
    end
  end
end
