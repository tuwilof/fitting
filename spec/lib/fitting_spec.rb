require 'spec_helper'

RSpec.describe Fitting do
  describe '.configure' do
    it 'makes settings' do
      Fitting.configure do |config|
        config.drafter_yaml_path = 'doc/api.yaml'
      end
    end
  end

  describe '.statistics' do
    let(:config) { double }
    let(:responses) { double(add: nil, statistics: double(save: nil)) }

    it 'does not raise exception' do
      allow(RSpec).to receive(:configure).and_yield(config)
      allow(config).to receive(:after).and_yield
      allow(config).to receive(:before).and_yield
      allow(described_class).to receive(:response).and_return(double(request: nil))
      allow(Fitting::Storage::Documentation).to receive(:tomogram).and_return(double(to_hash: nil))
      allow(Fitting::Storage::Responses).to receive(:new).and_return(double(
                                                                       add: nil,
                                                                       statistics: double(save: nil)
      ))
      expect { subject.statistics }.not_to raise_exception
    end
  end
end
