require 'spec_helper'
require 'fitting/storage/responses'

RSpec.describe Fitting::Storage::Responses do
  describe '.new' do
    it 'does not raise exception' do
      expect { subject }.not_to raise_exception
    end
  end

  describe '#push' do
    after { Fitting::Storage::Responses.instance_variable_set(:@responses, nil) }

    it 'returns responses' do
      expect(subject.push(nil)).to eq([nil])
    end
  end

  describe '#all' do
    it 'returns responses' do
      expect(subject.all).to eq([])
    end
  end
end
