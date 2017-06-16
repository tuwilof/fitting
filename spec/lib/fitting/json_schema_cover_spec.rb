require 'spec_helper'
require 'fitting/json_schema_cover'

RSpec.describe Fitting::JSONSchemaCover do
  let(:main_json_schema) do
    {
      '$schema': 'http://json-schema.org/draft-04/schema#',
      'type': 'object',
      'properties': {
        'login': {
          'type': 'string'
        },
        'password': {
          'type': 'string'
        },
        'captcha': {
          'type': 'string'
        },
        'code': {
          'type': 'string'
        }
      }
    }
  end
  let(:json_schema) { main_json_schema.merge('required': %w[login password]) }

  subject { described_class.new(json_schema) }

  describe '.new' do
    it 'returns described class object' do
      expect(subject).to be_a(described_class)
    end
  end

  describe '#json_schemas' do
    let(:json_schemas) { [json_schema_two, json_schema_three] }
    let(:json_schema_two) { main_json_schema.merge('required': %w[login password captcha]) }
    let(:json_schema_three) { main_json_schema.merge('required': %w[login password code]) }

    it 'returns json-schemas' do
      expect(subject.json_schemas).to eq(json_schemas)
    end
  end

  describe '#combinations' do
    let(:json_schemas) { [json_schema_two, json_schema_three] }
    let(:json_schema_two) { main_json_schema.merge('required': %w[login password captcha]) }
    let(:json_schema_three) { main_json_schema.merge('required': %w[login password code]) }

    it 'returns json-schemas' do
      expect(subject.combinations).to eq([["required", "captcha"], ["required", "code"]])
    end
  end
end
