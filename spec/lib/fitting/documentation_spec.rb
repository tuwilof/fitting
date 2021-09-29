require 'spec_helper'

RSpec.describe Fitting::Documentation do
  let(:tomogram) { double(to_hash: [{ 'responses' => [{ 'status' => 200 }], 'method' => nil, 'path' => nil }]) }
  let(:white_list) { nil }

  subject { described_class.new(tomogram, white_list) }

  describe '#black' do
    it 'returns empty array' do
      expect(subject.black).to eq([])
    end

    context 'has whitelist' do
      let(:white_list) { {} }

      it 'returns responses array' do
        expect(subject.black).to eq(["\t 200 0"])
      end
    end
  end

  describe '#white' do
    it 'returns responses array' do
      expect(subject.white).to eq(["\t 200 0"])
    end

    context 'has whitelist' do
      let(:white_list) { {} }

      it 'returns empty array' do
        expect(subject.white).to eq([])
      end
    end
  end

  describe '#all' do
    it 'returns responses array' do
      expect(subject.all).to eq(["\t 200 0"])
    end
  end
end
