require 'spec_helper'

RSpec.describe Fitting::Route::Requests do
  let(:response_routes) do
    double(
      coverage: ['GET /sessions', 'POST /sessions', 'GET /users', 'POST /users'],
      not_coverage: ['DELETE /sessions', 'POST /sessions', 'DELETE /users', 'POST /users']
    )
  end

  subject { described_class.new(response_routes) }

  describe '.new' do
    it 'returns described class object' do
      expect(subject).to be_a(described_class)
    end
  end

  describe '#statistics' do
    let(:combine) { double(full_cover: [''], partial_cover: [''], no_cover: [''], to_hash: {}, max: 8) }

    before do
      allow(Fitting::Route::Requests::Combine).to receive(:new).and_return(combine)
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
