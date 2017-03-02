require 'spec_helper'

RSpec.describe Fitting::Documentation::Request::Route do
  let(:response_routes) { double(
    coverage: ['GET /sessions', 'POST /sessions', 'GET /users', 'POST /users'],
    not_coverage: ['DELETE /sessions', 'POST /sessions', 'DELETE /users', 'POST /users']
  ) }
  let(:stat) {
    {
      "full cover" => [
        {"GET /sessions" => {"cover" => [""], "not_cover" => [], "all" => "✔ "}},
        {"GET /users" => {"cover" => [""], "not_cover" => [], "all" => "✔ "}}
      ],
      "partial cover" => [
        {"POST /sessions" => {"cover" => [""], "not_cover" => [""], "all" => "✖ "}},
        {"POST /users" => {"cover" => [""], "not_cover" => [""], "all" => "✖ "}}
      ],
      "no cover" => [
        {"DELETE /sessions" => {"cover" => [], "not_cover" => [""], "all" => "✖ "}},
        {"DELETE /users" => {"cover" => [], "not_cover" => [""], "all" => "✖ "}}
      ]
    }
  }

  subject { described_class.new(response_routes) }

  describe '.new' do
    it 'returns described class object' do
      expect(subject).to be_a(described_class)
    end
  end

  describe '#coverage_statistic' do
    it 'returns coverage_statistic' do
      expect(subject.coverage_statistic).to eq(stat)
    end
  end

  describe '#to_hash' do
    it 'returns hash' do
      expect(subject.to_hash).to eq(stat)
    end
  end

  describe '#fully_implemented' do
    it 'returns fully_implemented' do
      expect(subject.fully_implemented).to eq(["GET\t/sessions\t\t\t\t\t\t\t✔ ", "GET\t/users\t\t\t\t\t\t\t\t✔ "])
    end
  end

  describe '#partially_implemented' do
    it 'returns partially_implemented' do
      expect(subject.partially_implemented).to eq(["POST\t/sessions\t\t\t\t\t\t\t✖ ", "POST\t/users\t\t\t\t\t\t\t\t✖ "])
    end
  end

  describe '#no_implemented' do
    it 'returns no_implemented' do
      expect(subject.no_implemented).to eq(["DELETE\t/sessions\t\t\t\t\t\t\t✖ ", "DELETE\t/users\t\t\t\t\t\t\t\t✖ "])
    end
  end

  describe '#conformity_lists' do
    before { allow(STDOUT).to receive(:puts) }

    it 'does not return error' do
      expect { subject.conformity_lists }.not_to raise_error
    end
  end

  describe '#statistics' do
    before { allow(STDOUT).to receive(:puts) }

    it 'does not return error' do
      expect { subject.statistics }.not_to raise_error
    end
  end
end
