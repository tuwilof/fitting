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

  describe '#join' do
    let(:json_schema) do
      {
        "type" => "object",
        "required" => ["a"],
        "properties" => {
          "a" => {"type" => "integer"}
        }
      }
    end
    let(:tested_body) { double(to_s: body, add_json_schema: nil) }
    let(:body) { { "a" => 5 } }

    it 'does not rais exception' do
      expect { subject.join(tested_body) }.not_to raise_exception
    end

    context 'json-schema is incorrect' do
      let(:body) { "<html><body><a href=\"http://localhost:3000/\">redirected</a>.</body></html>" }

      it 'does not rais exception' do
        expect { subject.join(tested_body) }.not_to raise_exception
      end
    end

    context 'json-schema is not valid' do
      let(:body) { {} }

      it 'does not rais exception' do
        expect { subject.join(tested_body) }.not_to raise_exception
      end
    end
  end
end
