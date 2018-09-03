require 'spec_helper'
require 'fitting/cover'

RSpec.describe Fitting::Cover do
  subject { described_class.new(all_responses, coverage) }

  let(:all_responses) { {} }
  let(:coverage) { double }

  describe '.new' do
    it 'returns described class object' do
      expect(subject).to be_a(described_class)
    end
  end

  describe '#save' do
    let(:coverage) { double(coverage: nil) }

    it 'does not raise exception' do
      expect { subject.save }.not_to raise_exception
    end
  end

  describe '#to_hash' do
    let(:all_responses) do
      [
        double(route: "POST\t/sessions 200 0", documented?: true),
        double(route: "POST\t/sessions 200 0", documented?: true)
      ]
    end
    let(:coverage) do
      [
        "POST\t/sessions 200 0"
      ]
    end
    let(:to_hash) { double }
    let(:response) { double(update: nil, to_hash: to_hash) }

    before { allow(Fitting::Cover::Response).to receive(:new).and_return(response) }

    it 'returns hash' do
      expect(subject.to_hash).to eq("POST\t/sessions 200 0" => to_hash)
    end
  end
end
