require 'spec_helper'

RSpec.describe Fitting::Configuration do
  subject { described_class.new }

  describe '.new' do
    it 'returns described class object' do
      expect(subject).to be_a(described_class)
    end
  end
end
