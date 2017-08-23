require 'spec_helper'

RSpec.describe Fitting::Request do
  let(:env_request) { double(request_method: 'method', env: {}, fullpath: 'path') }
  let(:tomogram) { double(find_request: nil) }
  subject { described_class.new(env_request, tomogram) }

  describe '#route' do
    before { subject.instance_variable_set(:@schema, double(method: 'method', path: 'path')) }

    it 'returns route' do
      expect(subject.route).to eq("method\tpath")
    end
  end

  describe '#real_method_with_path' do
    it 'returns real method with path' do
      expect(subject.real_method_with_path).to eq("method\tpath")
    end
  end

  describe '#schemas_of_possible_responses' do
    before { subject.instance_variable_set(:@schema, double(find_responses: [{ 'body' => 'response' }])) }

    it 'returns schemas of possible responses' do
      expect(subject.schemas_of_possible_responses(status: '200')).to eq(['response'])
    end
  end

  describe '#within_prefix??' do
    let(:env_request) { double(request_method: nil, env: { 'PATH_INFO' => '' }, fullpath: nil) }

    it 'returns true' do
      expect(subject.within_prefix?('')).to be_truthy
    end
  end
end
