require 'spec_helper'
require 'fitting/records/documented/json_schema'

RSpec.describe Fitting::Records::Documented::JsonSchema do
  subject { described_class.new(json_schema) }

  describe '#to_h' do
    let(:json_schema) { double }

    it 'return json_schema' do
      expect(subject.to_h).to eq(json_schema)
    end
  end
end
