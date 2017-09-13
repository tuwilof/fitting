require 'spec_helper'

RSpec.describe Fitting::Configuration do
  describe '.craft' do
    context 'there is a yaml file' do
      before do
        allow(described_class).to receive(:one_yaml?).and_return(true)
        allow(described_class).to receive(:one_yaml)
      end

      it 'does not raise expection' do
        expect { described_class.craft }.not_to raise_exception
      end
    end

    context 'there is a yaml files' do
      before do
        allow(described_class).to receive(:one_yaml?).and_return(false)
        allow(described_class).to receive(:more_than_one_yaml?).and_return(true)
        allow(described_class).to receive(:more_than_one_yaml)
      end

      it 'does not raise expection' do
        expect { described_class.craft }.not_to raise_exception
      end
    end

    context 'there is a legacy file' do
      before do
        allow(described_class).to receive(:one_yaml?).and_return(false)
        allow(described_class).to receive(:more_than_one_yaml?).and_return(false)
        allow(described_class).to receive(:legacy)
      end

      it 'does not raise expection' do
        expect { described_class.craft }.not_to raise_exception
      end
    end
  end

  describe '.one_yaml?' do
    it 'returns false' do
      expect(described_class.one_yaml?).to be_falsey
    end
  end

  describe '.more_than_one_yaml?' do
    it 'returns false' do
      expect(described_class.more_than_one_yaml?).to be_falsey
    end
  end

  describe '.one_yaml' do
    before do
      allow(File).to receive(:read).and_return("--- {}\n")
    end

    it 'does not raise expection' do
      expect { described_class.one_yaml }.not_to raise_exception
    end
  end

  describe '.more_than_one_yaml' do
    before do
      allow(File).to receive(:read).and_return("--- {}\n")
      allow(described_class).to receive(:files).and_return([''])
    end

    it 'does not raise expection' do
      expect { described_class.more_than_one_yaml }.not_to raise_exception
    end
  end

  describe '.legacy' do
    it 'does not raise expection' do
      expect { described_class.legacy }.not_to raise_exception
    end
  end

  describe '.files' do
    it 'returns empty array' do
      expect(described_class.files).to eq([])
    end
  end
end
