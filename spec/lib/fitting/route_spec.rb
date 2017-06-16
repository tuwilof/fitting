require 'spec_helper'

RSpec.describe Fitting::Route do
  let(:all_responses) { nil }
  let(:routes) { nil }
  let(:strict) { nil }

  subject { described_class.new(all_responses, routes, strict) }

  before do
    allow(Fitting::Route::Coverage).to receive(:new).and_return(double(not_coverage: %w[first second]))
    allow(Fitting::Route::Requests).to receive(:new).and_return(double(conformity_lists: nil, statistics: nil))
  end

  describe '#statistics_with_conformity_lists' do
    let(:requests) { double(statistics: 'request statistics', conformity_lists: 'request conformity_lists') }
    let(:responses) { double(statistics: 'response statistics') }
    let(:all_ready) { false }

    before do
      allow(Fitting::Route::Coverage).to receive(:new).and_return(double(not_coverage: double(empty?: all_ready)))
      allow(Fitting::Route::Requests).to receive(:new).and_return(requests)
      allow(Fitting::Route::Responses).to receive(:new).and_return(responses)
    end

    it 'return statistics_with_conformity_lists' do
      expect(subject.statistics_with_conformity_lists).to eq(
        "request conformity_lists\n\nrequest statistics\n\nresponse statistics"
      )
    end

    context 'all ready' do
      let(:all_ready) { true }

      it 'returns all ready' do
        expect(subject.statistics_with_conformity_lists).to eq(
          "request conformity_lists\n\nrequest statistics\n\nresponse statistics\n\n"\
          'All responses are 100% valid! Great job!'
        )
      end
    end
  end

  describe '#errors' do
    it 'returns errors' do
      expect(subject.errors).to eq("first\nsecond\n")
    end
  end

  describe 'cover_save' do
    let(:cover) { double(save: nil) }

    before { allow(Fitting::Cover).to receive(:new).and_return(cover) }

    it 'does not raise exception' do
      expect { subject.cover_save }.not_to raise_exception
    end
  end
end
