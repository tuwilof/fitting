require 'spec_helper'

RSpec.describe Fitting::Storage::Documentation do
  describe '.tomogram' do
    let(:tomogram_craft) { double }

    before do
      allow(Fitting).to receive(:configuration).and_return(double(tomogram: true, drafter_yaml: nil, apib_path: nil))
      allow(TomogramRouting::Tomogram).to receive(:craft).and_return(tomogram_craft)
    end

    it 'returns tomogram craft' do
      expect(described_class.tomogram).to eq(tomogram_craft)
    end
  end
end
