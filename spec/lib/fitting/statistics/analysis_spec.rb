require 'spec_helper'
require 'fitting/statistics/analysis'

RSpec.describe Fitting::Statistics::Analysis do
  subject { described_class.new(measurement, '') }

  describe '#to_s' do
    let(:measurement) { double }

    before do
      allow(Fitting::Statistics::Lists).to receive(:new).and_return(double(to_s: 'list'))
      allow(Fitting::Statistics::RequestsStats).to receive(:new).and_return(double(to_s: 'requests stats'))
      allow(Fitting::Statistics::ResponsesStats).to receive(:new).and_return(double(to_s: 'responses stats'))
      allow(Fitting::Statistics::Great).to receive(:new).and_return(double(to_s: 'great'))
    end

    it 'return analysis string' do
      expect(subject.to_s).to eq("list\n\nrequests stats\n\nresponses stats\n\ngreat")
    end
  end
end
