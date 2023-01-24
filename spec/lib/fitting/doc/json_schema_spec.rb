require 'rspec'
require 'fitting/doc/json_schema'

describe Fitting::Doc::JsonSchema do
  let(:fixture) { YAML.load(File.read('spec/fixtures/json_schema/.fitting.debug.yml')) }

  subject(:json_schema) { described_class.new(fixture["json_schema"]) }

  it do
    fixture["jsons"].each do |log|
      json_schema.cover!(double(body:log))
    end
    doc_to_hash_lock = []
    res = json_schema.report(doc_to_hash_lock, 0)
    expect(res[0].map{|r| r ? r : "null"}).to eq(fixture["res_after"])
  end
end
