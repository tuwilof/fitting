require 'spec_helper'
require 'fitting/records/unit/json_schema'

RSpec.describe Fitting::Records::Unit::JsonSchema do
  subject { described_class.new(json_schema, tested_bodies) }

  describe 'bodies' do
    let(:json_schema) do
      {
        'type' => 'object',
        'required' => ['a'],
        'properties' => {
          'a' => { 'type' => 'integer' }
        }
      }
    end
    let(:valid_body) { { 'a' => 5 } }
    let(:invalid_body) { {} }
    let(:html_body) { '<html><body><a href="http://localhost:3000/">redirected</a>.</body></html>' }
    let(:tested_bodies) { [valid_body, invalid_body, html_body] }

    it 'returns bodies' do
      expect(subject.bodies).to eq([valid_body, html_body])
    end
  end
end
