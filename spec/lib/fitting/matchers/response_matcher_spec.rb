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
  let(:response) { double(fully_validates: double(any?: true)) }

  before do
    allow(Fitting::Storage::Documentation).to receive(:tomogram)
    allow(Fitting::Response).to receive(:new).and_return(response)
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
    let(:any?) { true }
    let(:response) {
      double(
        documented?: documented?,
        real_request_with_status: 'real request with status',
        fully_validates: double(any?: any?),
        got: 'got',
        diff: 'diff',
        expected: 'expected'
      )
    }

    before { subject.instance_variable_set(:@response, response) }

    context 'not documented' do
      let(:documented?) { false }

      it 'returns error message' do
        expect(subject.failure_message).to eq("response not documented\ngot: real request with status")
      end
    end

    context 'not valid?' do
      let(:any?) { false }

      it 'returns error message' do
        expect(subject.failure_message)
          .to eq("response does not conform to json-schema\nschemas: \nexpected\n\ngot: got\n\nerrors: \ndiff\n")
      end
    end

    it 'does not return message' do
      expect(subject.failure_message).to be_nil
    end
  end
end
