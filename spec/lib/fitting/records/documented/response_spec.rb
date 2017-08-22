require 'spec_helper'
require 'fitting/records/documented/response'

RSpec.describe Fitting::Records::Documented::Response do
  subject { described_class.new(tomogram_response, request) }

  let(:tomogram_response) { double }
  let(:request) { double }

  describe '#add_json_schema' do
    let(:tomogram_response) { {'body' => nil} }

    it 'does not rais exception' do
      expect { subject.add_json_schema(tomogram_response) }.not_to raise_exception
    end
  end

  describe '#join' do
    let(:tomogram_response) { {'status' => nil} }
    let(:tomogram_responses) { [double(status: double(to_s: nil), body: nil), double(status: double(to_s: '200'))] }

    before do
      allow(Fitting::Records::Documented::JsonSchema).to receive(:new).and_return(double(join: nil))
      subject.add_json_schema({'body' => nil})
    end

    it 'does not rais exception' do
      expect { subject.join(tomogram_responses) }.not_to raise_exception
    end
  end
end
