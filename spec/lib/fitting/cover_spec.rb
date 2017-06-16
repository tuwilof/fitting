require 'spec_helper'
require 'fitting/cover'

RSpec.describe Fitting::Cover do
  subject { described_class.new(all_responses, coverage) }

  let(:all_responses) { double }
  let(:coverage) { double }

  describe '.new' do
    it 'returns described class object' do
      expect(subject).to be_a(described_class)
    end
  end

  describe '#save' do
    let(:coverage) { double(coverage: nil) }

    it 'does not raise exception' do
      expect { subject.save }.not_to raise_exception
    end
  end
end
