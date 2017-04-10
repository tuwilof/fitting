require 'spec_helper'

RSpec.describe Fitting::Route do
  let(:all_responses) { nil }
  let(:routes) { nil }
  let(:strict) { nil }

  subject { described_class.new(all_responses, routes, strict) }

  describe '#statistics' do
    let(:request) { double(statistics: 'request statistics') }
    let(:responses) { double(statistics: 'responses.statistics') }

    before do
      allow(Fitting::Route::Requests).to receive(:new).and_return(request)
      allow(Fitting::Route::Responses).to receive(:new).and_return(request)
    end

    it 'return statistics' do
      expect(subject.statistics).to eq("request statistics\n\nrequest statistics")
    end
  end

  describe '#statistics_with_conformity_lists' do
    let(:request) { double(statistics: 'request statistics', conformity_lists: 'request conformity_lists') }
    let(:responses) { double(statistics: 'responses.statistics') }

    before do
      allow(Fitting::Route::Requests).to receive(:new).and_return(request)
      allow(Fitting::Route::Responses).to receive(:new).and_return(request)
    end

    it 'return statistics_with_conformity_lists' do
      expect(subject.statistics_with_conformity_lists).to eq(
        "request conformity_lists\n\nrequest statistics\n\nrequest statistics"
      )
    end
  end

  describe '#errors' do
    before { allow(Fitting::Route::Coverage).to receive(:new).and_return(double(not_coverage: ['first', 'second'])) }

    it 'returns errors' do
      expect(subject.errors).to eq("first\nsecond\n")
    end
  end
end
