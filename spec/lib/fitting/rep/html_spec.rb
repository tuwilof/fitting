require 'spec_helper'
require 'fitting/rep/html'

RSpec.describe Fitting::Rep::HTML do
  it do
    expect { described_class.bootstrap('spec/fixtures/report', {}, {}) }.not_to raise_error
  end
end