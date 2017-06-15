require 'spec_helper'
require 'fitting/route/requests/coverage'

RSpec.describe Fitting::Route::Requests::Coverage do
  subject { described_class.new(route_coverage) }

  let(:route_coverage) { double(coverage: ["POST\t/sessions 200 0"], not_coverage: []) }

  describe '.new' do
    it 'returns described class object' do
      expect(subject).to be_a(described_class)
    end
  end

  describe '#to_hash' do
    it 'returns hash routes' do
      expect(subject.to_hash).to eq(
        'POST /sessions' => { 'cover' => ['200 0'], 'not_cover' => [], 'all' => ['✔ 200 0'] }
      )
    end
  end
end
