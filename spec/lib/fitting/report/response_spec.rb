require 'spec_helper'

RSpec.describe Fitting::Report::Response do
  let(:name) { 'name' }

  subject { described_class.new(name, double(to_hash: nil)) }

  describe '.new' do
    it 'returns described class object' do
      expect(subject).to be_a(described_class)
    end
  end

  describe '#save' do
    it 'does not return error' do
      expect { subject.save }.not_to raise_error
      File.delete(name)
    end
  end
end
