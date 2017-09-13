require 'spec_helper'
require 'fitting/storage/responses'

RSpec.describe Fitting::Storage::Responses do
  describe '#add' do
    before { allow(Fitting::Records::Tested::Request).to receive(:new) }

    it 'does not raise an error' do
      expect { subject.add(double) }.not_to raise_exception
    end
  end

  describe '#statistics' do
    before do
      allow(Fitting::Statistics).to receive(:new)
      allow(subject).to receive(:documented)
    end

    it 'does not raise an error' do
      expect { subject.statistics }.not_to raise_exception
    end
  end
end
