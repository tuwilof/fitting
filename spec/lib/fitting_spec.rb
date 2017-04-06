require 'spec_helper'

RSpec.describe Fitting do
  describe '.configure' do
    it 'makes settings' do
      Fitting.configure do |config|
        config.drafter_yaml_path = 'doc/api.yaml'
      end
    end
  end
end
