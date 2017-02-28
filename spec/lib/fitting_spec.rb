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

    before do
      allow(subject).to receive(:origin_run_specs)
      allow(Fitting::Storage::Responses).to receive(:nil?).and_return(false)
      allow(Fitting::Documentation::Response::Route).to receive(:new).and_return(double(cover_ratio: nil))
      allow(Fitting::Report::Response).to receive(:new).and_return(double(save: nil))
    end

    after { Fitting::Storage::Responses.instance_variable_set(:@responses, nil) }

    it 'does not return error' do
      expect { subject.run_specs(double) }.not_to raise_error
    end
  end
end
