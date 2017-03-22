require 'spec_helper'

RSpec.describe Fitting::Route::Responses do
  let(:routes) { double(size: 0) }
  let(:coverage) { double(coverage: double(size: 0), cover_ratio: 0.0, not_coverage: double(size: 0)) }

  subject { described_class.new(routes, coverage) }

  describe '#statistics' do
    it do
      expect(subject.statistics).to eq(
        "API responses conforming to the blueprint: 0 (0.0% of 0).\n"\
        "API responses with validation errors or untested: 0 (100.0% of 0)."
      )
    end
  end
end
