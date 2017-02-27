require 'spec_helper'

RSpec.describe Fitting::Report::Response do
  subject { described_class.new(double(to_hash: nil)) }

  describe '.new' do
    it 'returns described class object' do
      expect(subject).to be_a(described_class)
    end
  end

  describe '#save' do
    it 'does not return error' do
      expect { subject.save }.not_to raise_error
      File.delete(described_class::NAME)
    end
  end
end
