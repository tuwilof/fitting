require 'spec_helper'
require 'fitting/storage/white_list'

RSpec.describe Fitting::Storage::WhiteList do
  subject { described_class.new(white_list, resource_white_list, nil) }

  let(:white_list) { nil }
  let(:resource_white_list) { nil }

  describe '.new' do
    it 'does not raise exception' do
      expect { subject }.not_to raise_exception
    end
  end

  describe '#to_a' do
    it 'does not raise exception' do
      expect { subject.to_a }.not_to raise_exception
    end

    context 'white list' do
      let(:white_list) { double }

      it 'returns white list' do
        expect(subject.to_a).to eq(white_list)
      end
    end

    context 'resource white list' do
      let(:resource_white_list) { double }
      let(:new_white_list) { double }

      before { allow(subject).to receive(:transformation).and_return(new_white_list) }

      it 'returns new white list' do
        expect(subject.to_a).to eq(new_white_list)
      end
    end
  end

  describe '#transformation' do
    it 'does not raise exception' do
      expect { subject.transformation }.not_to raise_exception
    end
  end
end
