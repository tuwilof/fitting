require 'spec_helper'
require 'fitting/cover/json_schema'
require 'json'

RSpec.describe Fitting::Cover::JSONSchema do
  subject { described_class.new(json_schema) }

  describe '#combi' do
    context 'default' do
      let(:json_schema) { MultiJson.load(File.read('spec/fixtures/example1.json')) }
      let(:json_schema_two) { MultiJson.load(File.read('spec/fixtures/example3.json')) }
      let(:json_schema_three) { MultiJson.load(File.read('spec/fixtures/example4.json')) }
      let(:combi1) { %w[required captcha] }
      let(:combi2) { %w[required code] }

      it 'returns combinations' do
        expect(subject.combi).to eq([[json_schema_two, combi1], [json_schema_three, combi2]])
      end
    end

    context 'attachments' do
      let(:json_schema) { MultiJson.load(File.read('spec/fixtures/example5.json')) }
      let(:json_schema_two) { MultiJson.load(File.read('spec/fixtures/example6.json')) }
      let(:json_schema_three) { MultiJson.load(File.read('spec/fixtures/example7.json')) }
      let(:combi1) { %w[required properties.result.login] }
      let(:combi2) { %w[required properties.result.password] }

      it 'returns combinations' do
        expect(subject.combi).to eq([[json_schema_two, combi1], [json_schema_three, combi2]])
      end
    end
  end
end
