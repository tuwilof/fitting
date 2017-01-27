require 'spec_helper'

RSpec.describe Fitting do
  it 'makes settings' do
    Fitting.configure do |config|
      config.tomogram = 'doc/api.yaml'
    end
  end
end
