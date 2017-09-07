require 'spec_helper'
require 'fitting/records/documented/request'

RSpec.describe Fitting::Records::Documented::Request do
  subject { described_class.new(tomogram_request, white_list) }

  let(:tomogram_request) { double }
  let(:white_list) { double }

  describe '#method' do
    let(:method) { double }
    let(:tomogram_request) { {'method' => method} }

    it 'returns method' do
      expect(subject.method).to eq(method)
    end
  end

  describe '#path' do
    let(:path) { double }
    let(:tomogram_request) { {'path' => path} }

    it 'returns method' do
      expect(subject.path).to eq(path)
    end
  end

  describe '#json_schema' do
    let(:json_schema) { double }
    let(:tomogram_request) { {'json_schema' => json_schema} }

    it 'returns json_schema' do
      expect(subject.json_schema).to eq(json_schema)
    end
  end

  describe '#responses' do
    let(:json_schema1) { double }
    let(:json_schema2) { double }
    let(:json_schema3) { double }
    let(:tomogram_request) do
      {
        'responses' =>
          [
            {"status" => "200", "body" => json_schema1},
            {"status" => "200", "body" => json_schema2},
            {"status" => "400", "body" => json_schema3}
          ]
      }
    end

    it 'returns responses' do
      expect(subject.responses).to eq(
        [
          {"status" => "200", "json_schemas" => [json_schema1, json_schema2]},
          {"status" => "400", "json_schemas" => [json_schema3]}
        ]
      )
    end
  end

  describe '#white' do
    context 'white list nil' do
      let(:white_list) { nil }

      it 'returns true' do
        expect(subject.white).to be_truthy
      end
    end

    context 'white list path nil' do
      let(:path) { double }
      let(:tomogram_request) { {'path' => double(to_s: path)} }
      let(:white_list) { {path => nil} }

      it 'returns false' do
        expect(subject.white).to be_falsey
      end
    end

    context 'white list path empty' do
      let(:path) { double }
      let(:tomogram_request) { {'path' => double(to_s: path)} }
      let(:white_list) { {path => []} }

      it 'returns true' do
        expect(subject.white).to be_truthy
      end
    end

    context 'white list path include method' do
      let(:path) { double }
      let(:method) { double }
      let(:tomogram_request) { {'path' => double(to_s: path), 'method' => method} }
      let(:white_list) { {path => [method]} }

      it 'returns true' do
        expect(subject.white).to be_truthy
      end
    end

    context 'white list path include other method' do
      let(:path) { double }
      let(:method1) { double }
      let(:method2) { double }
      let(:tomogram_request) { {'path' => double(to_s: path), 'method' => method1} }
      let(:white_list) { {path => [method2]} }

      it 'returns false' do
        expect(subject.white).to be_falsey
      end
    end
  end
end
