require 'spec_helper'
require 'fitting/records/tested/request'

RSpec.describe Fitting::Records::Tested::Request do
  subject { described_class.new(env_response, double) }

  describe '#method' do
    let(:method) { double }
    let(:env_response) { double(request: double(request_method: method)) }

    it 'returns method' do
      expect(subject.method).to eq(method)
    end
  end

  describe '#path' do
    let(:path) { double }
    let(:env_response) { double(request: double(env: { 'PATH_INFO' => path })) }

    before { allow(Tomograph::Path).to receive(:new).and_return(path) }

    it 'returns method' do
      expect(subject.path).to eq(path)
    end
  end

  describe '#body' do
    let(:body) { double }
    let(:env_response) { double(request: double(env: { 'action_dispatch.request.request_parameters' => body })) }

    it 'returns body' do
      expect(subject.body).to eq(body)
    end
  end

  describe '#response' do
    let(:response) { double }
    let(:env_response) { double }

    it 'returns response' do
      expect(subject.response).to be_a(Fitting::Records::Tested::Response)
    end
  end
end
