require 'spec_helper'

RSpec.describe Fitting::Storage::Skip do
  describe '.set' do
    it 'no error' do
      expect { described_class.set(true) }.not_to raise_exception
    end
  end

  describe '.get' do
    it 'returns value' do
      expect(described_class.get).to eq(true)
    end
  end
end
