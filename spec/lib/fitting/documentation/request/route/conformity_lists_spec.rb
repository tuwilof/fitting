require 'spec_helper'

RSpec.describe Fitting::Documentation::Request::Route::ConformityLists do
  let(:request_routes) { double(
    fully_implemented: double(join: 'FKR'),
    partially_implemented: double(join: 'PI'),
    no_implemented: double(join: 'NI')
  ) }

  subject { described_class.new(request_routes) }

  describe '#to_s' do
    it 'does not return error' do
      expect(subject.to_s).to eq([
        ['Fully conforming requests:', 'FKR'].join("\n"),
        ['Partially conforming requests:', 'PI'].join("\n"),
        ['Non-conforming requests:', 'NI'].join("\n")
      ].join("\n\n"))
    end
  end
end
