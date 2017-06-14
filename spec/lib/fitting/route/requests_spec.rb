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

  describe '#to_hash' do
    it 'returns hash' do
      expect(subject.to_hash).to eq(stat)
    end
  end

  describe '#statistics' do
    before do
      allow(subject).to receive(:coverage_statistic)
      subject.instance_variable_set(:@full_cover, [''])
      subject.instance_variable_set(:@partial_cover, [''])
      subject.instance_variable_set(:@no_cover, [''])
    end

    it 'returns statistics' do
      expect(subject.statistics).to eq([
        'API requests with fully implemented responses: 1 (33.33% of 3).',
        'API requests with partially implemented responses: 1 (33.33% of 3).',
        'API requests with no implemented responses: 1 (33.33% of 3).'
      ].join("\n"))
    end
  end

  describe '#conformity_lists' do
    let(:lists) { double }

    before do
      allow(Fitting::Route::Requests::Lists).to receive(:new).and_return(double(to_s: lists))
    end

    it 'returns conformity lists' do
      expect(subject.conformity_lists).to eq(lists)
    end
  end
end
