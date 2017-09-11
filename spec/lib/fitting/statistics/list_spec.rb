require 'spec_helper'
require 'fitting/statistics/list'

RSpec.describe Fitting::Statistics::List do
  subject { described_class.new(coverage, max_response_path) }

  let(:coverage) { double }
  let(:max_response_path) { double }

  describe '#responses_stat' do
    let(:max_response_path) { 2 }
    let(:request) do
      double(
        path: double(to_s: double(size: 8)),
        responses: double(to_a: responses)
      )
    end
    let(:responses) do
      [
        double(
          json_schemas: [
            double(bodies: []),
            double(bodies: nil)
          ],
          status: 200
        )
      ]
    end

    it 'returns responses stat string' do
      expect(subject.responses_stat(request)).to eq("\t\t\t\t✖ 200 ✔ 200")
    end
  end

  describe '#list_sort' do
    let(:request1) { double(path: double(to_s: 'b')) }
    let(:request2) { double(path: double(to_s: 'a')) }
    let(:coverage) do
      [
        request1,
        request2
      ]
    end

    it 'returns list sort' do
      expect(subject.list_sort).to eq([request2, request1])
    end
  end

  describe '#to_s' do
    let(:list_sort) do
      [
        double(
          method: 'method',
          path: 'path'
        )
      ]
    end

    before do
      allow(subject).to receive(:list_sort).and_return(list_sort)
      allow(subject).to receive(:responses_stat).and_return('responses_stat')
    end

    it 'returns list string' do
      expect(subject.to_s).to eq("method\tpathresponses_stat")
    end
  end
end
