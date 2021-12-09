require 'spec_helper'
require 'fitting/storage/responses'

RSpec.describe Fitting::Storage::Responses do
  describe '#add' do
    before { allow(Fitting::Records::Tested::Request).to receive(:new) }

    it 'does not raise an error' do
      expect { subject.add(double, double) }.not_to raise_exception
    end
  end
end
