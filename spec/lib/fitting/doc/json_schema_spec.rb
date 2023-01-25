require 'rspec'
require 'fitting/doc/json_schema'
require 'yaml'
require 'byebug'

describe Fitting::Doc::JsonSchema do
  subject(:json_schema) { described_class.new(fixture["json_schema"]) }

  context 'bug 1' do
    let(:fixture) { YAML.load(File.read('spec/fixtures/bugs/bug1/.fitting.debug.yml')) }

    it 'fixed' do
      fixture["jsons"].each do |log|
        json_schema.cover!(double(body: log))
      end
      doc_to_hash_lock = []
      res = json_schema.report(doc_to_hash_lock, 0)
      expect(res[0].map { |r| r ? r : "null" }).to eq(fixture["res_after"])
    end
  end

  context 'bug 2' do
    let(:fixture) { YAML.load(File.read('spec/fixtures/bugs/bug2/.fitting.debug.yml')) }

    it 'fixed' do
      fixture["jsons"].each do |log|
        json_schema.cover!(double(body: log))
      end
      doc_to_hash_lock = []
      res = json_schema.report(doc_to_hash_lock, 0)
      expect(res[0].map { |r| r ? r : "null" }).to eq(fixture["res_after"])
    end
  end

  context 'bug 3' do
    let(:fixture) { YAML.load(File.read('spec/fixtures/bugs/bug2/.fitting.debug.yml')) }

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
