require 'spec_helper'

RSpec.describe Fitting do
  describe '.configure' do
    it 'makes settings' do
      Fitting.configure do |config|
        config.tomogram = 'doc/api.yaml'
      end
    end
  end
end

RSpec.describe RSpec::Core::Runner do
  describe '#run_specs' do
    subject { described_class.new(double) }

    let(:not_coverage_present) { false }

    before do
      allow(subject).to receive(:origin_run_specs).and_return(0)
      allow(Fitting::Storage::Responses).to receive(:nil?).and_return(false)
      allow(Fitting::Documentation::Response::Route).to receive(:new).and_return(double(
        cover_ratio: 0.0, coverage: [], all: [], statistics: nil, not_coverage: double(present?: not_coverage_present)
      ))
      allow(Fitting::Documentation::Request::Route).to receive(:new).and_return(double(
        conformity_lists: nil, statistics: nil
      ))
      Fitting::Storage::Skip.set(false)
      allow(Fitting).to receive(:configuration)
        .and_return(double(necessary_fully_implementation_of_responses: nil))
      allow(Fitting::Storage::Documentation).to receive(:hash)
    end

    after { Fitting::Storage::Skip.set(true) }

    it 'does not return error' do
      expect { subject.run_specs(double) }.not_to raise_error
    end

    context 'necessary_fully_implementation_of_responses and not_coverage.present? true' do
      let(:not_coverage_present) { true }

      before do
        allow(Fitting).to receive(:configuration)
          .and_return(double(necessary_fully_implementation_of_responses: true))
      end

      it 'does not return error' do
        expect { subject.run_specs(double) }.not_to raise_error
      end
    end
  end
end
