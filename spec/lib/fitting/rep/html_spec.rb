require 'spec_helper'
require 'fitting/rep/html'

RSpec.describe Fitting::Rep::HTML do
  let(:fitting_json) {
    {
      "POST project.test/user": [
        nil,
        4612,
        3828,
        10,
        10
      ],
      "GET project.test/user": [
        nil,
        4612,
        3828,
        10,
        0,
        0
      ],
      "DELETE project.test/user": [
        nil,
        4612,
        3828,
        0,
        0,
        0
      ]
    }
  }
  it do
    expect { described_class.bootstrap('spec/fixtures/report', JSON.dump(fitting_json), {}) }.not_to raise_error
  end
end