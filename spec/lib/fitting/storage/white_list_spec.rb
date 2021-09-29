require 'spec_helper'
require 'fitting/storage/white_list'

RSpec.describe Fitting::Storage::WhiteList do
  subject do
    described_class.new(
      prefix,
      white_list,
      resource_white_list,
      include_resources,
      include_actions,
      resources
    )
  end

  let(:prefix) { nil }
  let(:white_list) { nil }
  let(:resource_white_list) { nil }
  let(:include_resources) { nil }
  let(:include_actions) { nil }
  let(:resources) { nil }
  let(:new_white_list) { double }

  describe '.new' do
    it 'does not raise exception' do
      expect { subject }.not_to raise_exception
    end
  end

  describe '#to_a' do
    before { allow(subject).to receive(:transformation).and_return(new_white_list) }

    it 'does not raise exception' do
      expect { subject.to_a }.not_to raise_exception
    end

    it 'returns nil' do
      expect(subject.to_a).to be_nil
    end

    context 'white list' do
      let(:white_list) { double }

      it 'returns white list' do
        expect(subject.to_a).to eq(white_list)
      end
    end

    context 'resource white list' do
      let(:resource_white_list) { double }

      before { allow(subject).to receive(:transformation).and_return(new_white_list) }

      it 'returns new white list' do
        expect(subject.to_a).to eq(new_white_list)
      end
    end

    context 'include_resources' do
      let(:include_resources) { double }

      before { allow(subject).to receive(:new_transformation).and_return({}) }

      it 'returns new white list' do
        expect(subject.to_a).to eq({})
      end
    end

    context 'include_actions' do
      let(:include_actions) { double }

      before { allow(subject).to receive(:postnew_transformation).and_return({}) }

      it 'returns new white list' do
        expect(subject.to_a).to eq({})
      end
    end
  end

  describe '#transformation' do
    it 'does not raise exception' do
      allow(subject).to receive(:transformation).and_return(new_white_list)
      expect { subject.transformation }.not_to raise_exception
    end

    context 'with details' do
      let(:resource_white_list) do
        {
          '/users' => ['DELETE /users/{id}', 'POST /users', 'GET /users/{id}', 'PATCH /users/{id}'],
          '/dogs' => ['GET /dogs/{id}', 'PATCH /dogs/{id}']
        }
      end
      let(:res) do
        {
          '/users' => ['POST'],
          '/users/{id}' => %w[DELETE GET PATCH],
          '/dogs/{id}' => %w[GET PATCH]
        }
      end

      it 'returns transformation' do
        expect(subject.transformation).to eq(res)
      end
    end

    context 'without details' do
      let(:resource_white_list) do
        {
          '/users' => []
        }
      end
      let(:res) do
        {
          '/users/{id}' => %w[DELETE GET PATCH],
          '/users' => ['POST']
        }
      end
      let(:resources) do
        {
          '/users' => ['DELETE /users/{id}', 'POST /users', 'GET /users/{id}', 'PATCH /users/{id}']
        }
      end

      it 'returns transformation' do
        expect(subject.transformation).to eq(res)
      end
    end
  end

  describe '#requests' do
    let(:resource) { [double] }
    let(:all_requests) { [] }
    let(:request_hash) { double }

    before { allow(subject).to receive(:request_hash).and_return(request_hash) }

    it 'returns requests' do
      expect(subject.requests(resource, all_requests)).to eq([request_hash])
    end

    context 'resource nil' do
      it 'returns all_requests' do
        expect(subject.requests(resource, all_requests)).to eq(all_requests)
      end
    end
  end

  describe '#request_hash' do
    let(:request) { 'method path' }

    it 'returns request_hash' do
      expect(subject.request_hash(request)).to eq(method: 'method', path: 'path')
    end
  end

  describe '#without_group' do
    let(:resource_white_list) { [[[], []]] }
    let(:resources) { {} }

    before { allow($stdout).to receive(:puts) }

    it 'returns without_group' do
      expect(subject.without_group).to eq([])
    end
  end

  describe '#new_transformation' do
    it 'does not raise exception' do
      allow(subject).to receive(:new_transformation).and_return(new_white_list)
      expect { subject.new_transformation }.not_to raise_exception
    end

    context 'default' do
      let(:include_resources) do
        [
          '/users'
        ]
      end
      let(:res) do
        {
          '/users/{id}' => %w[DELETE GET PATCH],
          '/users' => ['POST']
        }
      end
      let(:resources) do
        {
          '/users' => ['DELETE /users/{id}', 'POST /users', 'GET /users/{id}', 'PATCH /users/{id}']
        }
      end

      it 'returns transformation' do
        expect(subject.new_transformation).to eq(res)
      end
    end

    context 'without slesh' do
      let(:include_resources) do
        [
          'users'
        ]
      end
      let(:res) do
        {
          '/users/{id}' => %w[DELETE GET PATCH],
          '/users' => ['POST']
        }
      end
      let(:resources) do
        {
          '/users' => ['DELETE /users/{id}', 'POST /users', 'GET /users/{id}', 'PATCH /users/{id}']
        }
      end

      it 'returns transformation' do
        expect(subject.new_transformation).to eq(res)
      end
    end

    context 'warning' do
      before { allow($stdout).to receive(:puts) }
      let(:include_resources) do
        [
          '/lol'
        ]
      end
      let(:res) { {} }
      let(:resources) do
        {
          '/users' => ['DELETE /users/{id}', 'POST /users', 'GET /users/{id}', 'PATCH /users/{id}']
        }
      end

      it 'returns transformation' do
        expect(subject.new_transformation).to eq(res)
      end
    end
  end

  describe '#postnew_transformation' do
    it 'does not raise exception' do
      allow(subject).to receive(:postnew_transformation).and_return(new_white_list)
      expect { subject.postnew_transformation }.not_to raise_exception
    end

    context 'default' do
      let(:include_actions) do
        [
          'DELETE /users/{id}',
          'POST /users',
          'GET /users/{id}',
          'PATCH /users/{id}'
        ]
      end
      let(:res) do
        {
          '/users/{id}' => %w[DELETE GET PATCH],
          '/users' => ['POST']
        }
      end
      let(:resources) do
        {
          '/users' => ['DELETE /users/{id}', 'POST /users', 'GET /users/{id}', 'PATCH /users/{id}']
        }
      end

      it 'returns transformation' do
        expect(subject.postnew_transformation).to eq(res)
      end
    end

    context 'without slesh' do
      let(:include_actions) do
        [
          'DELETE users/{id}',
          'POST users',
          'GET /users/{id}',
          'PATCH /users/{id}'
        ]
      end
      let(:res) do
        {
          '/users/{id}' => %w[DELETE GET PATCH],
          '/users' => ['POST']
        }
      end
      let(:resources) do
        {
          '/users' => ['DELETE /users/{id}', 'POST /users', 'GET /users/{id}', 'PATCH /users/{id}']
        }
      end

      it 'returns transformation' do
        expect(subject.postnew_transformation).to eq(res)
      end
    end
  end
end
