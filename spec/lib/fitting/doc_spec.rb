require 'spec_helper'
require 'fitting/doc'

RSpec.describe Fitting::Doc do
  describe '.all' do
    let(:yaml) { YAML.safe_load(File.read('spec/fixtures/.fitting.yml')) }

    subject { described_class.all(yaml) }

    it 'parses path and prefix for provided APIs' do
      expect(subject.first.path).to eq('json_schemas/main_api.json')
      expect(subject.first.prefix).to eq('/api/v1')
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
end
