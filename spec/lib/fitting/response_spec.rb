require 'spec_helper'
require 'fitting/response'

RSpec.describe Fitting::Response do
  let(:env_response) { double(request: nil, status: nil, body: nil) }
  let(:tomogram) { double }
  let(:request) { double(schemas_of_possible_responses: schemas_of_possible_responses, path: 'path') }
  let(:schemas_of_possible_responses) { nil }

  before { allow(Fitting::Request).to receive(:new).with(env_response.request, tomogram).and_return(request) }

  subject { described_class.new(env_response, tomogram) }

  describe '#fully_validates' do
    let(:fully_validates) { double }

    before { allow(Fitting::Response::FullyValidates).to receive(:craft).and_return(fully_validates) }

    it 'returns fully_validates' do
      expect(subject.fully_validates).to eq(fully_validates)
    end
  end

  describe '#strict_fully_validates' do
    let(:strict_fully_validates) { double }

    before { allow(Fitting::Response::FullyValidates).to receive(:craft).and_return(strict_fully_validates) }

    it 'returns strict_fully_validates' do
      expect(subject.strict_fully_validates).to eq(strict_fully_validates)
    end
  end

  describe '#documented?' do
    let(:schemas_of_possible_responses) { double(present?: true) }

    it 'returns true' do
      expect(subject.documented?).to be_truthy
    end
  end

  describe '#route' do
    let(:request) { double(schemas_of_possible_responses: schemas_of_possible_responses, route: 'route') }
    let(:env_response) { double(request: nil, status: 'status', body: nil) }
    let(:schemas_of_possible_responses) { double(size: 1) }

    before { allow(Fitting::Response::FullyValidates).to receive(:craft).and_return([[]]) }

    it 'returns route' do
      expect(subject.route).to eq(['route status 0'])
    end
  end

  describe '#strict_route' do
    let(:request) { double(schemas_of_possible_responses: schemas_of_possible_responses, route: 'route') }
    let(:env_response) { double(request: nil, status: 'status', body: nil) }
    let(:schemas_of_possible_responses) { double(size: 1) }

    before { allow(Fitting::Response::FullyValidates).to receive(:craft).and_return([[]]) }

    it 'returns strict_route' do
      expect(subject.strict_route).to eq(['route status 0'])
    end
  end

  describe '#real_request_with_status' do
    let(:request) do
      double(
        schemas_of_possible_responses: schemas_of_possible_responses,
        real_method_with_path: 'real_method_with_path'
      )
    end
    let(:env_response) { double(request: nil, status: 'status', body: nil) }

    it 'returns real_request_with_status' do
      expect(subject.real_request_with_status).to eq('real_method_with_path status')
    end
  end

  describe '#got' do
    let(:env_response) { double(request: nil, status: nil, body: body) }
    let(:body) { '{}' }

    it 'returns body' do
      expect(subject.got).to eq("{\n}")
    end
  end

  describe '#expected' do
    let(:schemas_of_possible_responses) { %w[schema1 schema2] }

    it 'returns expected' do
      expect(subject.expected).to eq("\"schema1\"\n\n\"schema2\"")
    end
  end

  describe '#within_prefix??' do
    let(:request) do
      double(
        within_prefix?: true,
        schemas_of_possible_responses: schemas_of_possible_responses
      )
    end

    it 'returns true' do
      expect(subject.within_prefix?('')).to be_truthy
    end
  end

  describe '#json_schema' do
    let(:request) { double(schemas_of_possible_responses: schemas_of_possible_responses, route: 'route') }
    let(:env_response) { double(request: nil, status: 'status', body: nil) }
    let(:schemas_of_possible_responses) { ['{}'] }

    before { allow(Fitting::Response::FullyValidates).to receive(:craft).and_return([[]]) }

    it 'returns json_schema' do
      expect(subject.json_schema).to eq('{}')
    end
  end

  describe '#body' do
    let(:body) { double }
    let(:request) { double(schemas_of_possible_responses: schemas_of_possible_responses, route: 'route') }
    let(:env_response) { double(request: nil, status: 'status', body: body) }
    let(:schemas_of_possible_responses) { ['{}'] }

    before { allow(Fitting::Response::FullyValidates).to receive(:craft).and_return([[]]) }

    it 'returns json_schema' do
      expect(subject.body).to eq(body)
    end
  end

  describe '#ignored?' do
    before { allow(request).to receive(:ignored?).and_return(true) }

    it 'call #ignored? to request' do
      expect(subject.ignored?([/path/])).to eq(true)
    end
  end
end
