require 'spec_helper'
require 'fitting/statistics'

RSpec.describe Fitting::Statistics do
  subject { described_class.new(tested_requests) }

  let(:tested_requests) { [] }

  describe '#save' do
    before do
      allow(subject).to receive(:make_dir)
      allow(Fitting).to receive(:configuration).and_return(double(is_a?: false))
      allow(Fitting::Statistics::Template).to receive(:new).and_return(double(save: nil))
    end

    it 'does not raise expection' do
      expect { subject.save }.not_to raise_exception
    end

    context 'config is array' do
      before { allow(Fitting).to receive(:configuration).and_return([double(title: nil)]) }

      it 'does not raise expection' do
        expect { subject.save }.not_to raise_exception
      end
    end
  end

  describe '#make_dir' do
    after { FileUtils.rm_r 'test' }

    it 'does not raise expection' do
      expect { subject.make_dir('test') }.not_to raise_exception
    end
  end
end
