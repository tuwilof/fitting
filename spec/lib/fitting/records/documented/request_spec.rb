require 'spec_helper'
require 'fitting/records/documented/request'

RSpec.describe Fitting::Records::Documented::Request do
  subject { described_class.new(tomogram_request, white_list) }

  let(:tomogram_request) do
    {
      'method' => nil,
      'path' => nil,
      'json_schema' => nil
    }
  end
  let(:white_list) { double(to_a: nil) }

  describe '#grouping' do
    it 'returns grouping' do
      expect(subject.grouping(
        [
          {
            "status" => "401",
            "body" => {}
          },
          {
            "status" => "429",
            "body" => {}
          }
        ]
      )).to eq(
        {
          "401" => [{}],
          "429" => [{}]
        }
      )

      expect(subject.grouping(
        [
          {
            "status" => "401",
            "body" => {}
          },
          {
            "status" => "401",
            "body" => {}
          }
        ]
      )).to eq(
        {
          "401" => [{}, {}]
        }
      )
    end
  end
end
