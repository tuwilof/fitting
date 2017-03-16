require 'spec_helper'

RSpec.describe Fitting::Storage::Documentation do
  describe '.tomogram' do
    let(:tomogram_craft) { double }

    before { allow(TomogramRouting::Tomogram).to receive(:craft).and_return(tomogram_craft) }

    it 'returns tomogram craft' do
      expect(described_class.tomogram).to eq(tomogram_craft)
    end
  end
end
