require 'spec_helper'

RSpec.configure do |config|
  config.include Fitting::Matchers
end

RSpec.describe Fitting::Matchers do
  describe '.match_response' do
    it 'returns matcher response object' do
      expect(match_response).to be_a(described_class::Response)
    end
  end
end

RSpec.describe Fitting::Matchers::Response do
  let(:response) { double(valid?: true) }

  before do
    allow(Fitting::Storage::Documentation).to receive(:tomogram)
    allow(Fitting::Response).to receive(:new).and_return(response)
    allow(Fitting::Storage::Responses).to receive(:push)
  end

  subject { described_class.new }

  describe '#matches?' do
    it 'returns true' do
      expect(subject.matches?(nil)).to be_truthy
    end
  end

  describe '#===' do
    it 'returns true' do
      expect(subject === nil).to be_truthy
    end
  end

  describe '#failure_message' do
    let(:documented?) { true }
    let(:valid?) { true }
    let(:response) {
      double(
        documented?: documented?,
        real: 'real',
        valid?: valid?,
        got: 'got',
        diff: 'diff',
        expected: 'expected'
      )
    }

    before { subject.instance_variable_set(:@response, response) }

    context 'not documented' do
      let(:documented?) { false }

      it 'returns error message' do
        expect(subject.failure_message).to eq("response not documented\ngot: real")
      end
    end

    context 'not valid?' do
      let(:valid?) { false }

      it 'returns error message' do
        expect(subject.failure_message)
          .to eq("response not valid json-schema\ngot: got\ndiff: \ndiffexpected: \nexpected\n")
      end
    end

    it 'does not return message' do
      expect(subject.failure_message).to be_nil
    end
  end
end
