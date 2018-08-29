require 'spec_helper'
require 'fitting/statistics/requests_stats'

RSpec.describe Fitting::Statistics::RequestsStats do
  subject { described_class.new(measurement) }

  describe '#to_s' do
    let(:measurement) do
      double(
        requests: double(size: 0),
        coverage_fully: double(size: 0),
        coverage_partially: double(size: 0),
        coverage_non: double(size: 0)
      )
    end

    it 'returns requests stats string' do
      expect(subject.to_s)
        .to eq(
          "API requests with fully implemented responses: 0 (0.0% of 0).\n"\
          "API requests with partially implemented responses: 0 (0.0% of 0).\n"\
          'API requests with no implemented responses: 0 (0.0% of 0).'
        )
    end
  end
end
