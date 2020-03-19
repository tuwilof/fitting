require 'spec_helper'
require 'fitting/cover/json_schema'
require 'json'

RSpec.describe Fitting::Cover::JSONSchema do
  subject { described_class.new(original) }

  describe '#combi' do
    let(:original) { MultiJson.load(File.read('spec/fixtures/required/0.json')) }
    let(:first_combination) { MultiJson.load(File.read('spec/fixtures/required/1.json')) }
    let(:second_combination) { MultiJson.load(File.read('spec/fixtures/required/2.json')) }
    let(:first_details) { %w[required required.captcha] }
    let(:second_details) { %w[required required.code] }

    it 'returns combinations' do
      expect(subject.combi).to eq([[first_combination, first_details], [second_combination, second_details]])
    end

    it 'does not change original' do
      subject.combi
      expect(original).to eq(MultiJson.load(File.read('spec/fixtures/required/0.json')))
    end

    context 'attachments' do
      let(:original) { MultiJson.load(File.read('spec/fixtures/required/attachments_0.json')) }
      let(:first_combination) { MultiJson.load(File.read('spec/fixtures/required/attachments_1.json')) }
      let(:second_combination) { MultiJson.load(File.read('spec/fixtures/required/attachments_2.json')) }
      let(:first_details) { %w[required properties.result.required.login] }
      let(:second_details) { %w[required properties.result.required.password] }

      it 'returns combinations' do
        expect(subject.combi).to eq([[first_combination, first_details], [second_combination, second_details]])
      end
    end

    context 'remember the neighbors' do
      let(:original) { MultiJson.load(File.read('spec/fixtures/required/definitions_0.json')) }

      it 'returns combinations' do
        res = subject.combi
        expect(res[0][1][1]).to eq("definitions.Login.required.login")

        expect(res[0][0]).to eq(MultiJson.load(File.read('spec/fixtures/required/definitions_1.json')))
      end
    end

    context 'many' do
      let(:original) { MultiJson.load(File.read('spec/fixtures/required/many_0.json')) }

      it 'returns combinations' do
        res = subject.combi
        expect(res.size).to eq(2)
        expect(res[0][1][1]).to eq("properties.logins.required.login")
        expect(res[1][1][1]).to eq("properties.passwords.required.password")
      end
    end
  end
end
