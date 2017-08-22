require 'spec_helper'
require 'fitting/records/documented/request'

RSpec.describe Fitting::Records::Documented::Request do
  subject { described_class.new(tomogram_request) }

  let(:tomogram_request) do
    {
      'method' => nil,
      'path' => nil,
      'json_schema' => nil
    }
  end

  describe '#add_responses' do
    let(:tomogram_responses) { [double, double] }
    let(:responses) { double(add_responses: nil) }

    before do
      allow(Fitting::Records::Documented::Response).to receive(:new).and_return(double(status: nil, add_json_schema: nil))
    end

    it 'does not rais exception' do
      expect { subject.add_responses(tomogram_responses, responses) }.not_to raise_exception
    end
  end

  describe '#join' do
    let(:tested_request) { double(responses: nil) }

    before do
      allow(Fitting::Records::Documented::Response).to receive(:new).and_return(double(status: nil, add_json_schema: nil, join: nil))
      subject.add_responses([double], double(add_responses: nil))
    end

    it 'does not rais exception' do
      expect { subject.join(tested_request) }.not_to raise_exception
    end
  end

  describe '#joind_white_list' do
  end

  describe '#state' do
  end
end
