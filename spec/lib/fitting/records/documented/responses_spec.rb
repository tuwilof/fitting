require 'spec_helper'
require 'fitting/records/documented/responses'

RSpec.describe Fitting::Records::Documented::Responses do
  describe '#add' do
    it 'does not rais exception' do
      expect { subject.add(double) }.not_to raise_exception
    end
  end

  describe '#add_responses' do
    it 'does not rais exception' do
      expect { subject.add_responses([]) }.not_to raise_exception
    end
  end

  describe '#to_a' do
    it 'does not rais exception' do
      expect { subject.to_a }.not_to raise_exception
    end
  end
end
