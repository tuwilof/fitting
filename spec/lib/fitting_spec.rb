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
    let(:filename) { 'filename.txt' }

    before do
      Fitting::Storage::Skip.set(false)
      allow(STDOUT).to receive(:puts)
      allow(subject).to receive(:origin_run_specs).and_return(0)
      allow(Fitting::Statistics).to receive(:new).and_return(double(save: nil, not_coverage?: true))
      allow(Fitting).to receive(:configuration)
        .and_return(double(
          tomogram: 'doc/api.yaml',
          create_report_with_name: filename,
          strict: false,
          necessary_fully_implementation_of_responses: false,
          white_list: nil,
          show_statistics_in_console: true
        ))
    end

    after { Fitting::Storage::Skip.set(true) }

    it 'does not return error' do
      expect { subject.run_specs(double) }.not_to raise_error
    end

    context 'necessary_fully_implementation_of_responses and not_coverage.present? true' do
      let(:not_coverage_present) { true }

      before do
        allow(Fitting).to receive(:configuration)
          .and_return(double(
            tomogram: 'doc/api.yaml',
            create_report_with_name: nil,
            strict: false,
            necessary_fully_implementation_of_responses: true,
            white_list: nil,
            show_statistics_in_console: true
          ))
      end

      it 'does not return error' do
        expect { subject.run_specs(double) }.not_to raise_error
      end
    end
  end
end
