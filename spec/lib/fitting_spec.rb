require 'spec_helper'

RSpec.describe Fitting do
  describe '.configure' do
    it 'makes settings' do
      Fitting.configure do |config|
        config.drafter_yaml_path = 'doc/api.yaml'
      end
    end
  end

  describe '.add_to_stats' do
    before do
      allow(Fitting::Response).to receive(:new)
      allow(Fitting::Storage::Responses).to receive(:push)
      allow(Fitting::Storage::Documentation).to receive(:tomogram)
    end

    it 'does not raise exception' do
      expect { subject.add_to_stats(double) }.not_to raise_exception
    end
  end

  describe '.generate_stats' do
    before do
      allow(Fitting::Statistics).to receive(:new).and_return(double(save: stats))
      allow(Fitting::Documentation).to receive(:new)
      allow(Fitting::Storage::Documentation).to receive(:tomogram)
      allow(Fitting).to receive(:configuration).and_return(double(white_list: nil, strict: nil))
      allow(Fitting::Storage::Responses).to receive(:all)
    end

    let(:stats) { double }

    it 'returns stats' do
      expect(subject.generate_stats).to eq(stats)
    end
  end
end
