require 'rspec'
require 'fitting/doc/json_schema'
require 'fitting/debug'
require 'yaml'
require 'byebug'

describe Fitting::Doc::JsonSchema do
  subject(:json_schema) { described_class.new(fixture["json_schema"], false) }

  context 'bug 1' do
    let(:fixture) { YAML.load(File.read('spec/fixtures/bugs/bug1/.fitting.debug.yml')) }

    it 'fixed' do
      fixture["jsons"].each do |log|
        json_schema.cover!(double(body: log))
      end
      doc_to_hash_lock = fixture["res_before"].map { |r| nil }
      res = json_schema.report(doc_to_hash_lock, 0)

      res_debug = Fitting::Debug.report(0, json_schema, json_schema.logs)
      File.open('spec/fixtures/bugs/bug1/.fitting.test.yml', 'w') { |file| file.write(YAML.dump(res_debug)) }
      expect(res_debug['jsons'].size).to eq(fixture["jsons"].size)
      expect(res_debug['jsons']).to eq(fixture["jsons"])
      expect(res_debug['valid_jsons'].size).to eq(fixture["valid_jsons"].size)
      expect(res_debug['valid_jsons']).to eq(fixture["valid_jsons"])
      expect(res_debug['index_medium']).to eq(fixture["index_medium"])
      expect(res_debug['res_medium']).to eq(fixture["res_medium"])
      expect(res_debug['combinations']).to eq(fixture["combinations"])
      expect(res_debug['res_after']).to eq(fixture["res_after"])
      expect(res[0].map { |r| r ? r : "null" }).to eq(fixture["res_after"])

      expect(res[0].size).to eq(fixture["res_after"].size)
      expect(res[0].map { |r| r ? r : "null" }).to eq(fixture["res_after"])
    end
  end

  context 'bug 2' do
    let(:fixture) { YAML.load(File.read('spec/fixtures/bugs/bug2/.fitting.debug.yml')) }

    it 'fixed' do
      fixture["jsons"].each do |log|
        json_schema.cover!(double(body: log))
      end
      doc_to_hash_lock = fixture["res_before"].map { |r| nil }
      res = json_schema.report(doc_to_hash_lock, 0)

      res_debug = Fitting::Debug.report(0, json_schema, json_schema.logs)
      File.open('spec/fixtures/bugs/bug2/.fitting.test.yml', 'w') { |file| file.write(YAML.dump(res_debug)) }
      expect(res_debug['jsons'].size).to eq(fixture["jsons"].size)
      expect(res_debug['jsons']).to eq(fixture["jsons"])
      expect(res_debug['valid_jsons'].size).to eq(fixture["valid_jsons"].size)
      expect(res_debug['valid_jsons']).to eq(fixture["valid_jsons"])
      expect(res_debug['index_medium']).to eq(fixture["index_medium"])
      expect(res_debug['res_medium']).to eq(fixture["res_medium"])
      expect(res_debug['combinations']).to eq(fixture["combinations"])
      expect(res_debug['res_after']).to eq(fixture["res_after"])
      expect(res[0].map { |r| r ? r : "null" }).to eq(fixture["res_after"])

      expect(res[0].size).to eq(fixture["res_after"].size)
      expect(res[0].map { |r| r ? r : "null" }).to eq(fixture["res_after"])
    end
  end

  context 'bug 3' do
    let(:fixture) { YAML.load(File.read('spec/fixtures/bugs/bug3/.fitting.debug.yml')) }

    it 'fixed' do
      fixture["jsons"].each do |log|
        json_schema.cover!(double(body: log))
      end
      doc_to_hash_lock = fixture["res_before"].map { |r| nil }
      res = json_schema.report(doc_to_hash_lock, 0)

      res_debug = Fitting::Debug.report(0, json_schema, json_schema.logs)
      File.open('spec/fixtures/bugs/bug3/.fitting.test.yml', 'w') { |file| file.write(YAML.dump(res_debug)) }
      expect(res_debug['jsons'].size).to eq(fixture["jsons"].size)
      expect(res_debug['jsons']).to eq(fixture["jsons"])
      expect(res_debug['valid_jsons'].size).to eq(fixture["valid_jsons"].size)
      expect(res_debug['valid_jsons']).to eq(fixture["valid_jsons"])
      expect(res_debug['index_medium']).to eq(fixture["index_medium"])
      expect(res_debug['res_medium']).to eq(fixture["res_medium"])
      expect(res_debug['combinations']).to eq(fixture["combinations"])
      expect(res_debug['res_after']).to eq(fixture["res_after"])
      expect(res[0].map { |r| r ? r : "null" }).to eq(fixture["res_after"])

      expect(res[0].size).to eq(fixture["res_after"].size)
      expect(res[0].map { |r| r ? r : "null" }).to eq(fixture["res_after"])
    end
  end
end
