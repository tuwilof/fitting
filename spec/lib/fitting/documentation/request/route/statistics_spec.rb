require 'spec_helper'

RSpec.describe Fitting::Documentation::Request::Route::Statistics do
  let(:request_routes) do
    double(to_hash: {
      'full cover' => [''],
      'partial cover' => [''],
      'no cover' => ['']
    })
  end

  subject { described_class.new(request_routes) }

  describe '#to_s' do
    it 'does not return error' do
      expect(subject.to_s).to eq(
        "API requests with fully implemented responses: 1 (33.33% of 3).\n"\
        "API requests with partially implemented responses: 1 (33.33% of 3).\n"\
        "API requests with no implemented responses: 1 (33.33% of 3).\n"
      )
    end
  end
end
