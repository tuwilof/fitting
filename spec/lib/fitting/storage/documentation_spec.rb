require 'spec_helper'

RSpec.describe Fitting::Storage::Documentation do
  let(:tomogram_craft) { double }

  before do
    allow(Fitting).to receive(:configuration).and_return(double(apib_path: nil, drafter_yaml_path: nil, prefix: nil))
    allow(TomogramRouting::Tomogram).to receive(:craft).and_return(tomogram_craft)
    allow(Tomograph::Tomogram).to receive(:json).and_return(double)
  end

  describe '.tomogram' do
    it 'returns tomogram' do
      expect(described_class.tomogram).to eq(tomogram_craft)
    end
  end

  describe '.craft' do
    it 'returns tomogram' do
      expect(described_class.craft).to eq(tomogram_craft)
    end

    context 'call drafter' do
      it 'returns tomogram' do
        allow(Fitting).to receive(:configuration).and_return(double(apib_path: '', drafter_yaml_path: nil, prefix: nil))
        allow_any_instance_of(Kernel).to receive(:`).and_return('')
        expect(described_class.craft).to eq(tomogram_craft)
      end
    end
  end
end
