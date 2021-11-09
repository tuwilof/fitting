require 'spec_helper'

RSpec.describe Fitting::Configuration do
  describe '.craft' do
    context 'there is a yaml file' do
      it 'does not raise expection' do
        allow(File).to receive(:read).and_return("--- {}\n")
        expect { described_class.craft }.not_to raise_exception
      end
    end
  end
end
