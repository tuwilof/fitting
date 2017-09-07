require 'spec_helper'
require 'fitting/statistics/great'

RSpec.describe Fitting::Statistics::Great do
  subject { described_class.new(measurement) }

  describe '#to_s' do
    let(:measurement) { double(cover_responses: nil, all_responses: nil) }

    it 'return great string' do
      expect(subject.to_s).to eq("All responses are 100% valid! Great job!")
    end
  end
end
