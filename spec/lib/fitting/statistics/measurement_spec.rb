require 'spec_helper'
require 'fitting/statistics/measurement'

RSpec.describe Fitting::Statistics::Measurement do
  subject { described_class.new(requests) }

  let(:requests) do
    [
      double(
        responses: [
          double(
            json_schemas: json_schemas,
            status: 'status'
          )
        ],
        path: 'pathpath',
        method: 'method'
      )
    ]
  end
  let(:json_schemas) do
    [
      double(bodies: []),
      double(bodies: nil)
    ]
  end

  it 'does not raise an error' do
    expect { subject }.not_to raise_exception
  end

  context 'non cover' do
    let(:json_schemas) do
      [
        double(bodies: [])
      ]
    end

    it 'does not raise an error' do
      expect { subject }.not_to raise_exception
    end
  end

  context 'full cover' do
    let(:json_schemas) do
      [
        double(bodies: nil)
      ]
    end

    it 'does not raise an error' do
      expect { subject }.not_to raise_exception
    end
  end
end
