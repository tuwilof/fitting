require 'spec_helper'

RSpec.describe Fitting::Storage::Documentation do
  describe '.tomogram' do
    let(:tomogram_craft) { double }

    before { allow(TomogramRouting::Tomogram).to receive(:craft).and_return(tomogram_craft) }

    it 'returns tomogram craft' do
      expect(described_class.tomogram).to eq(tomogram_craft)
    end
  end

  describe '.hash' do
    let(:tomogram_configuration) { double }

    before { allow(Fitting).to receive(:configuration).and_return(double(tomogram: tomogram_configuration)) }

    it 'returns tomogram configuration' do
      expect(described_class.hash).to eq(tomogram_configuration)
    end
  end
end
