require 'spec_helper'
require 'fitting/storage/responses'

RSpec.describe Fitting::Storage::Responses do
  describe '.new' do
    it 'does not raise exception' do
      expect { subject }.not_to raise_exception
    end
  end

  describe '#add' do
    before do
      allow(Fitting::Response).to receive(:new)
      allow(Fitting::Storage::Documentation).to receive(:tomogram)
    end

    after { Fitting::Storage::Responses.instance_variable_set(:@responses, nil) }

    it 'returns responses' do
      expect(subject.add(nil)).to eq([nil])
    end
  end

  describe '#statistics' do
    before do
      allow(Fitting::Statistics).to receive(:new).and_return(statistics)
      allow(Fitting::Documentation).to receive(:new)
      allow(Fitting::Storage::Documentation).to receive(:tomogram).and_return(double(to_resources: nil))
      allow(Fitting).to receive(:configuration)
        .and_return(double(white_list: nil, strict: nil, resource_white_list: nil))
    end

    let(:statistics) { double }

    it 'returns statistics' do
      expect(subject.statistics).to eq(statistics)
    end
  end
end
