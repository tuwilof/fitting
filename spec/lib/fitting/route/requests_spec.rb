require 'spec_helper'

RSpec.describe Fitting::Route::Requests do
  let(:response_routes) do
    double(
      coverage: ['GET /sessions', 'POST /sessions', 'GET /users', 'POST /users'],
      not_coverage: ['DELETE /sessions', 'POST /sessions', 'DELETE /users', 'POST /users']
    )
  end
  let(:stat) do
    {
      'full cover' => [
        { 'GET /sessions' => { 'cover' => [''], 'not_cover' => [], 'all' => '✔ ' } },
        { 'GET /users' => { 'cover' => [''], 'not_cover' => [], 'all' => '✔ ' } }
      ],
      'partial cover' => [
        { 'POST /sessions' => { 'cover' => [''], 'not_cover' => [''], 'all' => '✖ ' } },
        { 'POST /users' => { 'cover' => [''], 'not_cover' => [''], 'all' => '✖ ' } }
      ],
      'no cover' => [
        { 'DELETE /sessions' => { 'cover' => [], 'not_cover' => [''], 'all' => '✖ ' } },
        { 'DELETE /users' => { 'cover' => [], 'not_cover' => [''], 'all' => '✖ ' } }
      ]
    }
  end

  subject { described_class.new(response_routes) }

  describe '.new' do
    it 'returns described class object' do
      expect(subject).to be_a(described_class)
    end
  end

  describe '#coverage_statistic' do
    it 'returns coverage_statistic' do
      expect(subject.coverage_statistic).to eq(stat)
    end
  end

  describe '#to_hash' do
    it 'returns hash' do
      expect(subject.to_hash).to eq(stat)
    end
  end

  describe '#statistics' do
    #let(:to_hash) { double(full_cover: [''], partial_cover: [''], no_cover: ['']) }
    let(:to_hash) { {'full cover' => [''], 'partial cover' => [''], 'no cover' => ['']} }

    before { allow(subject).to receive(:coverage_statistic).and_return(to_hash) }

    it 'returns statistics' do
      expect(subject.statistics).to eq([
        'API requests with fully implemented responses: 1 (33.33% of 3).',
        'API requests with partially implemented responses: 1 (33.33% of 3).',
        'API requests with no implemented responses: 1 (33.33% of 3).'
      ].join("\n"))
    end
  end
end
