require 'spec_helper'
require 'fitting/storage/white_list'

RSpec.describe Fitting::Storage::WhiteList do
  subject { described_class.new(white_list, resource_white_list, resources) }

  let(:white_list) { nil }
  let(:resource_white_list) { nil }
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
          '/users/{id}' => %w(DELETE GET PATCH),
          '/dogs/{id}' => %w(GET PATCH)
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
          '/users/{id}' => %w(DELETE GET PATCH),
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
end
