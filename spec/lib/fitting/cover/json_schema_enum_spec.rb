require 'spec_helper'
require 'fitting/cover/json_schema_enum'
require 'json-schema'
require 'json'

RSpec.describe Fitting::Cover::JSONSchemaEnum do
  subject { described_class.new(original) }

  describe '#combi' do
    let(:original) { JSON.parse(File.read('spec/fixtures/enum/0.json')) }
    let(:first_combination) { JSON.parse(File.read('spec/fixtures/enum/1.json')) }
    let(:second_combination) { JSON.parse(File.read('spec/fixtures/enum/2.json')) }
    let(:first_details) { %w[enum properties.state.enum.ok] }
    let(:second_details) { %w[enum properties.state.enum.error] }

    it 'returns combinations' do
      expect(subject.combi).to eq([[first_combination, first_details], [second_combination, second_details]])
    end

    context 'neighbors after' do
      let(:original) { JSON.parse(File.read('spec/fixtures/enum/neighbors_after_0.json')) }
      let(:first_combination) { JSON.parse(File.read('spec/fixtures/enum/neighbors_after_1.json')) }
      let(:second_combination) { JSON.parse(File.read('spec/fixtures/enum/neighbors_after_2.json')) }

      it 'returns combinations' do
        expect(subject.combi).to eq([[first_combination, first_details], [second_combination, second_details]])
      end
    end

    context 'if forever alone' do
      let(:original) { JSON.parse(File.read('spec/fixtures/enum/forever_alone_0.json')) }

      it 'returns empty array' do
        expect(subject.combi).to eq([])
      end
    end
  end
end
