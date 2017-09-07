require 'spec_helper'
require 'fitting/records/documented/response'

RSpec.describe Fitting::Records::Documented::Response do
  subject { described_class.new(tomogram_response) }

  let(:tomogram_response) { double }

  describe '#add_json_schema' do
    let(:tomogram_response) { {'body' => nil} }

    it 'does not rais exception' do
      expect { subject.add_json_schema(tomogram_response) }.not_to raise_exception
    end
  end
end
