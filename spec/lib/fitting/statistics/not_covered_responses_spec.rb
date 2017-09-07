require 'spec_helper'
require 'fitting/statistics/not_covered_responses'

RSpec.describe Fitting::Statistics::NotCoveredResponses do
  subject { described_class.new(measurement) }

  describe '#to_s' do
    let(:measurement) { double(not_covered_responses: ['response1', 'response2']) }

    it 'return not covered responses string' do
      expect(subject.to_s).to eq("response1\nresponse2\n")
    end
  end
end
