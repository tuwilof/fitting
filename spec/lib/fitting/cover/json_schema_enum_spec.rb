require 'spec_helper'
require 'fitting/cover/json_schema_enum'
require 'json-schema'
require 'json'

RSpec.describe Fitting::Cover::JSONSchemaEnum do
  let(:json_schema) do
    {
      "$schema" => "http://json-schema.org/draft-04/schema#",
      "type" => "object",
      "properties" => {
        "state" => {
          "type" => "string",
          "enum" => [
            "ok",
            "error"
          ]
        }
      },
      "required" => [
        "state"
      ]
    }
  end

  subject { described_class.new(json_schema) }

  describe '.new' do
    it 'returns described class object' do
      expect(subject).to be_a(described_class)
    end
  end

  describe '#combi' do
    it do
      expect(subject.combi).to eq(
        [
          [
            {
              "$schema" => "http://json-schema.org/draft-04/schema#",
              "type" => "object",
              "properties" => {
                "state" => {
                  "type" => "string",
                  "enum" => [
                    "ok"
                  ]
                }
              },
              "required" => [
                "state"
              ]
            },
            %w[enum properties.state.ok]
          ],
          [
            {
              "$schema" => "http://json-schema.org/draft-04/schema#",
              "type" => "object",
              "properties" => {
                "state" => {
                  "type" => "string",
                  "enum" => [
                    "error"
                  ]
                }
              },
              "required" => [
                "state"
              ]
            },
            %w[enum properties.state.error]
          ]
        ]
      )
    end
  end

  describe '#new_enum' do
    it do
      expect(subject.new_enum(
        {
          "type" => "string",
          "enum" => [
            "ok",
            "error"
          ]
        }
      )).to eq(
        [
          [
            {
              "type" => "string",
              "enum" => [
                "ok"
              ]
            },
            %w[enum ok]
          ],
          [
            {
              "type" => "string",
              "enum" => [
                "error"
              ]
            },
            %w[enum error]
          ]
        ]
      )
    end
  end

  describe "#new_keys" do
    it do
      expect(subject.new_keys(
        {
          "type" => "string",
          "enum" => [
            "ok",
            "error"
          ]
        }
      )).to eq(
        [
          "ok",
          "error"
        ]
      )
    end
  end
end
