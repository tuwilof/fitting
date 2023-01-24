require 'rspec'
require 'fitting/doc/json_schema'

describe Fitting::Doc::JsonSchema do
  subject(:json_schema) { described_class.new(fixture["json_schema"]) }

  context 'fixtures/json_schema/' do
    let(:fixture) { YAML.load(File.read('spec/fixtures/json_schema/.fitting.debug.yml')) }

    it 'report eq res_after' do
      fixture["jsons"].each do |log|
        json_schema.cover!(double(body: log))
      end
      doc_to_hash_lock = []
      res = json_schema.report(doc_to_hash_lock, 0)
      expect(res[0].map { |r| r ? r : "null" }).to eq(fixture["res_after"])
    end
  end

  context 'fixtures/json_schema_1' do
    let(:fixture) { YAML.load(File.read('spec/fixtures/json_schema_1/.fitting.debug.yml')) }

    it 'report eq res_after' do
      fixture["jsons"].each do |log|
        json_schema.cover!(double(body: log))
      end
      doc_to_hash_lock = []
      res = json_schema.report(doc_to_hash_lock, 0)
      expect(res[0].map { |r| r ? r : "null" }).to eq(fixture["res_after"])
    end
  end
end
