require 'spec_helper'
require 'fitting/statistics/percent'

RSpec.describe Fitting::Statistics::Percent do
  subject { described_class.new(divider, dividend) }

  describe '#percent' do
    let(:divider) { 5 }
    let(:dividend) { 4 }

    it 'return percent string' do
      expect(subject.to_s).to eq('80.0')
    end

    context 'divider == 0' do
      let(:divider) { 0 }

      it 'return 0 percent string' do
        expect(subject.to_s).to eq('0.0')
      end
    end
  end
end
