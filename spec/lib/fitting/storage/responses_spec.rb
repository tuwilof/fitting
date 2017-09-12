require 'spec_helper'
require 'fitting/storage/responses'

RSpec.describe Fitting::Storage::Responses do
  describe '#add' do
    before { allow(Fitting::Records::Tested::Request).to receive(:new) }

    it 'does not raise an error' do
      expect { subject.add(double) }.not_to raise_exception
    end
  end

  describe '#statistics' do
    before do
      allow(Fitting::Statistics).to receive(:new)
      allow(subject).to receive(:documented)
    end

    it 'does not raise an error' do
      expect { subject.statistics }.not_to raise_exception
    end
  end

  describe '#documented' do
    before do
      allow(Fitting::Records::Documented::Request).to receive(:new)
      allow(Fitting).to receive(:configuration).and_return(double(tomogram: double(to_hash: [double])))
      allow(subject).to receive(:white_list).and_return(double(to_a: nil))
    end

    it 'does not raise an error' do
      expect { subject.documented }.not_to raise_exception
    end
  end

  describe '#white_list' do
    before do
      allow(Fitting::Storage::WhiteList).to receive(:new)
      allow(Fitting).to receive(:configuration)
        .and_return(double(white_list: nil, resource_white_list: nil, tomogram: double(to_resources: nil)))
    end

    it 'does not raise an error' do
      expect { subject.white_list }.not_to raise_exception
    end
  end
end
