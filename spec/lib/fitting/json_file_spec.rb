require 'spec_helper'

describe Fitting::JsonFile do
  describe '.craft' do
    after { described_class.destroy }

    it 'not raise exception' do
      expect { described_class.craft }.not_to raise_exception
    end
  end

  describe '.save' do
    after { described_class.destroy }

    it 'not raise exception' do
      expect { described_class.save({}) }.not_to raise_exception
    end
  end

  describe '.push' do
    before { described_class.craft }
    after { described_class.destroy }

    it 'not raise exception' do
      expect { described_class.push('qwe', 'asd') }.not_to raise_exception
    end
  end

  describe '.tests' do
    before { described_class.craft }
    after { described_class.destroy }

    it 'not raise exception' do
      expect { described_class.tests }.not_to raise_exception
    end

    it 'get tests' do
      expect(described_class.tests).to eq({})
    end
  end

  describe '.load' do
    before { described_class.craft }
    after { described_class.destroy }

    it 'not raise exception' do
      expect { described_class.load }.not_to raise_exception
    end

    it 'get tests' do
      expect(described_class.load).to eq({})
    end
  end

  describe '.destroy' do
    before { described_class.craft }

    it 'not raise exception' do
      expect { described_class.destroy }.not_to raise_exception
    end
  end
end
