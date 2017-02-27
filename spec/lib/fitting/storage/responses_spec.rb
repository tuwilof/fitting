require 'spec_helper'

RSpec.describe Fitting::Storage::Responses do
  describe '.push' do
    after { Fitting::Storage::Responses.instance_variable_set(:@responses, nil) }

    it 'returns responses' do
      expect(described_class.push(nil)).to eq([nil])
    end
  end

  describe '.all' do
    it 'returns responses' do
      expect(described_class.all).to eq([])
    end
  end

  describe '.nil?' do
    before { Fitting::Storage::Responses.instance_variable_set(:@responses, nil) }

    it 'returns true' do
      expect(described_class.nil?).to be_truthy
    end
  end
end
