require 'spec_helper'
require 'fitting/statistics/responses_stats'

RSpec.describe Fitting::Statistics::ResponsesStats do
  subject { described_class.new(measurement) }

  describe '#to_s' do
    let(:measurement) do
      double(
        all_responses: 0,
        cover_responses: 0,
        not_cover_responses: 0
      )
    end

    it 'returns requests stats string' do
      expect(subject.to_s)
        .to eq(
          "API responses conforming to the blueprint: 0 (0.0% of 0).\n"\
          "API responses with validation errors or untested: 0 (0.0% of 0)."
        )
    end
  end
end
