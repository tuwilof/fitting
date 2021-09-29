require 'spec_helper'
require 'fitting/cover/json_schema_one_of'
require 'json-schema'
require 'json'

RSpec.describe Fitting::Cover::JSONSchemaOneOf do
  subject { described_class.new(original) }

  describe '#combi' do
    let(:original) { JSON.parse(File.read('spec/fixtures/one_of/0.json')) }
    let(:first_combination) { JSON.parse(File.read('spec/fixtures/one_of/1.json')) }
    let(:second_combination) { JSON.parse(File.read('spec/fixtures/one_of/2.json')) }
    let(:first_details) { %w[one_of oneOf.0] }
    let(:second_details) { %w[one_of oneOf.1] }

    it 'returns combinations' do
      expect(subject.combi).to eq([[first_combination, first_details], [second_combination, second_details]])
    end
  end

  describe '#combi nested' do
    let(:original) { JSON.parse(File.read('spec/fixtures/one_of/nested_0.json')) }
    let(:first_combination) { JSON.parse(File.read('spec/fixtures/one_of/nested_1.json')) }
    let(:second_combination) { JSON.parse(File.read('spec/fixtures/one_of/nested_2.json')) }
    let(:first_details) { %w[one_of properties.errors.oneOf.0] }
    let(:second_details) { %w[one_of properties.errors.oneOf.1] }

    it 'returns combinations' do
      expect(subject.combi).to eq([[first_combination, first_details], [second_combination, second_details]])
    end
  end
end
