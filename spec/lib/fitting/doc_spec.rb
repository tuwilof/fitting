require 'spec_helper'
require 'fitting/doc'
require 'tomograph'

RSpec.describe Fitting::Doc do
  describe '.all' do
    let(:yaml) { YAML.safe_load(File.read('spec/fixtures/.fitting.yml')) }

    subject { described_class.all(yaml) }

    it 'parses path and prefix for provided APIs' do
      expect(subject.first.path).to eq('json_schemas/main_api.json')
      expect(subject.first.prefix).to eq('/api/v1')
      expect(subject.first.class).to eq(Fitting::Doc::ProvidedAPI)
      expect(subject[1].path).to eq('json_schemas/admin_api.json')
      expect(subject[1].prefix).to eq('/api/admin')
    end

    it 'parses path and prefix for used APIs' do
      expect(subject[2].path).to eq('json_schemas/tarifficator.json')
      expect(subject[2].host).to eq('tarifficator.local')
      expect(subject[3].path).to eq('json_schemas/sso.json')
      expect(subject[3].host).to eq('sso.local')
    end
  end

  describe '.find' do
    let(:docs) do
      described_class.all(YAML.safe_load(File.read('spec/fixtures/.fitting.yml')))
    end

    subject { described_class.find!(docs, log) }

    context 'incoming request' do
      let(:log) do
        double(
          path: '/api/v1',
          method: 'POST',
          status: 200,
          body: { 'error' => 'Not found', 'error_description' => 'any error_description' },
          host: 'www.example.com',
          type: 'incoming'
        )
      end

      it do
        expect(subject).to eq(docs.first)
      end
    end

    context 'outgoing request' do
      let(:log) do
        double(
          path: '/api/v1/profile"',
          method: 'POST',
          status: 200,
          body: { 'error' => 'Not found', 'error_description' => 'any error_description' },
          host: 'sso.local',
          type: 'outgoing'
        )
      end

      it do
        expect(subject).to eq(docs[3])
      end
    end
  end
end
