require 'spec_helper'

RSpec.describe Fitting::Storage::Documentation do
  describe '.tomogram' do
    let(:tomogram_craft) { double }

    before do
      allow(Fitting).to receive(:configuration).and_return(double(apib_path: nil, drafter_yaml_path: nil, prefix: nil))
      allow(TomogramRouting::Tomogram).to receive(:craft).and_return(tomogram_craft)
      allow(Tomograph::Tomogram).to receive(:json).and_return(double)
    end

    it 'returns tomogram craft' do
      expect(described_class.tomogram).to eq(tomogram_craft)
    end
  end
end
