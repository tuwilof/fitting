require 'spec_helper'
require 'fitting/cover/json_schema'
require 'json'

RSpec.describe Fitting::Cover::JSONSchema do
  subject { described_class.new(original) }

  describe '#combi' do
    let(:original) { MultiJson.load(File.read('spec/fixtures/required/0.json')) }
    let(:first_combination) { MultiJson.load(File.read('spec/fixtures/required/1.json')) }
    let(:second_combination) { MultiJson.load(File.read('spec/fixtures/required/2.json')) }
    let(:first_details) { %w[required captcha] }
    let(:second_details) { %w[required code] }

    it 'returns combinations' do
      expect(subject.combi).to eq([[first_combination, first_details], [second_combination, second_details]])
    end

    context 'attachments' do
      let(:original) { MultiJson.load(File.read('spec/fixtures/required/attachments_0.json')) }
      let(:first_combination) { MultiJson.load(File.read('spec/fixtures/required/attachments_1.json')) }
      let(:second_combination) { MultiJson.load(File.read('spec/fixtures/required/attachments_2.json')) }
      let(:first_details) { %w[required properties.result.login] }
      let(:second_details) { %w[required properties.result.password] }

      it 'returns combinations' do
        expect(subject.combi).to eq([[first_combination, first_details], [second_combination, second_details]])
      end
    end
  end
end
