require 'spec_helper'

RSpec.configure do |config|
  config.include Fitting::Matchers
end

RSpec.describe Fitting::Matchers do
  describe '.match_schema' do
    it 'returns matcher response object' do
      expect(match_schema).to be_a(described_class::Response)
    end
  end

  describe '.strictly_match_schema' do
    it 'returns matcher strict response object' do
      expect(strictly_match_schema).to be_a(described_class::StrictResponse)
    end
  end
end

RSpec.describe Fitting::Matchers::Response do
  let(:response) { double(fully_validates: double(valid?: true), within_prefix?: true) }

  before do
    allow(response).to receive(:ignored?).and_return(false)
    allow(Fitting::Response).to receive(:new).and_return(response)
    allow(Fitting).to receive(:configuration).and_return(double(prefix: '', ignore_list: [], tomogram: nil))
  end

  describe '#matches?' do
    it 'returns true' do
      expect(subject.matches?(nil)).to be_truthy
    end

    context 'within_prefix? false' do
      let(:response) { double(fully_validates: double(valid?: true), within_prefix?: false) }

      it 'returns true' do
        expect(subject.matches?(nil)).to be_truthy
      end
    end

    context 'path ignored' do
      before do
        allow(response).to receive(:ignored?).and_return(true)
      end

      it 'returns true' do
        expect(subject.matches?(nil)).to be_truthy
      end
    end

    context 'config is array' do
      before do
        allow(Fitting).to receive(:configuration).and_return([double(prefix: '', ignore_list: [], tomogram: nil)])
      end

      it 'returns true' do
        expect(subject.matches?(nil)).to be_truthy
      end
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
    let(:response) do
      double(
        documented?: documented?,
        real_request_with_status: 'real request with status',
        fully_validates: double(valid?: valid?, to_s: 'diff'),
        got: 'got',
        expected: 'expected'
      )
    end

    before { subject.instance_variable_set(:@response, response) }

    context 'not documented' do
      let(:documented?) { false }

      it 'returns error message' do
        expect(subject.failure_message).to eq("response not documented\ngot: real request with status")
      end
    end

    context 'not valid?' do
      let(:valid?) { false }

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

RSpec.describe Fitting::Matchers::StrictResponse do
  let(:response) { double(strict_fully_validates: double(valid?: true)) }

  before do
    allow(Fitting::Response).to receive(:new).and_return(response)
    allow(Fitting).to receive(:configuration).and_return(double(tomogram: nil))
  end

  subject { described_class.new }

  describe '#matches?' do
    it 'returns true' do
      expect(subject.matches?(nil)).to be_truthy
    end

    context 'config is array' do
      before { allow(Fitting).to receive(:configuration).and_return([double(tomogram: nil)]) }

      it 'returns true' do
        expect(subject.matches?(nil)).to be_truthy
      end
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
    let(:response) do
      double(
        documented?: documented?,
        real_request_with_status: 'real request with status',
        strict_fully_validates: double(valid?: valid?, to_s: 'diff'),
        got: 'got',
        expected: 'expected'
      )
    end

    before { subject.instance_variable_set(:@response, response) }

    context 'not documented' do
      let(:documented?) { false }

      it 'returns error message' do
        expect(subject.failure_message).to eq("response not documented\ngot: real request with status")
      end
    end

    context 'not valid?' do
      let(:valid?) { false }

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
