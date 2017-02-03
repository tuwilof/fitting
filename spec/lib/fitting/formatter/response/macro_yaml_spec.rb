require 'spec_helper'
require 'fitting/formatter/response/macro_yaml'

describe Fitting::Formatter::Response::MacroYaml do
  subject { described_class.new(nil) }

  describe '#start' do
    it 'not raise exception' do
      expect { subject.start(nil) }.not_to raise_exception
    end
  end

  describe '#stop' do
    let(:report) { double(to_hash: {}) }

    before { allow(Fitting::Report::Response::Macro).to receive(:new).and_return(report) }

    it 'not raise exception' do
      expect { subject.stop(nil) }.not_to raise_exception
    end
  end
end
