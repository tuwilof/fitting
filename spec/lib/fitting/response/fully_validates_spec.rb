require 'spec_helper'
require 'fitting/response/fully_validates'

RSpec.describe Fitting::Response::FullyValidates do
  let(:schemas) { [] }
  subject { described_class.craft(schemas, {}) }

  describe '.craft' do
    it 'returns described_class object' do
      expect(subject).to be_a(described_class)
    end
  end

  describe '#valid?' do
    it 'returns false' do
      expect(subject.valid?).to be_falsey
    end

    context 'has one empty array' do
      let(:schemas) { [{}] }

      it 'returns true' do
        expect(subject.valid?).to be_truthy
      end
    end
  end

  describe '#to_s' do
    it 'returns empty String' do
      expect(subject.to_s).to eq('')
    end

    context 'has one empty array' do
      let(:schemas) { [{}] }

      it 'returns empty String' do
        expect(subject.to_s).to eq('')
      end
    end

    context 'has more than one empty array' do
      let(:schemas) { [{}, {}] }

      it 'returns a string with line breaks' do
        expect(subject.to_s).to eq("\n\n")
      end
    end
  end
end
