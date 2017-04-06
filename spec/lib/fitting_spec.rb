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
          white_list: nil
        ))
    end

    after { Fitting::Storage::Skip.set(true) }
  end
end
