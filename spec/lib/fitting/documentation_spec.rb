require 'spec_helper'
require 'multi_json'

RSpec.describe Fitting::Documentation do
  subject do
    described_class.try_on(double(inspect: '(lol)'), request, response)
  end

  before do
    allow(Fitting::Storage::JsonFile).to receive(:push)
    allow(Fitting).to receive(:configuration).and_return(
      double(
        tomogram: tomogram,
        skip_not_documented: skip_not_documented,
        validation_requests: validation_requests,
        validation_response: validation_response
      )
    )
  end
  let(:skip_not_documented) { true }
  let(:validation_requests) { true }
  let(:validation_response) { true }

  describe '#try_on' do
    let(:request_json_schema) do
      {
        "$schema": 'http://json-schema.org/draft-04/schema#',
        "type": 'object',
        "properties": {
          "example": {
            "type": 'string'
          }
        },
        "required": [
          'example'
        ]
      }
    end
    let(:response_json_schema) do
      {
        "$schema": 'http://json-schema.org/draft-04/schema#',
        "type": 'object',
        "properties": {
          "example": {
            "type": 'string'
          }
        },
        "required": [
          'example'
        ]
      }
    end
    let(:body_request) { '{"example":""}' }
    let(:body_response) { '{"example":""}' }
    let(:doc_response) do
      {
        'status' => '200',
        'body' => response_json_schema
      }
    end
    let(:doc_responses) { [doc_response, doc_response] }
    let(:tomogram) do
      MultiJson.dump(
        [
          {
            'path' => '/status',
            'method' => 'POST',
            'request' => request_json_schema,
            'responses' => doc_responses
          }
        ]
      )
    end
    let(:request_path) { '/status' }
    let(:response_status) { 200 }
    let(:request) do
      double(
        request_method: 'POST',
        env: {
          'PATH_INFO' => request_path,
          'action_dispatch.request.request_parameters' => body_request
        }
      )
    end
    let(:response) { double(status: response_status, body: body_response) }

    context 'request and response is not valid ' do
      let(:body_request) { '{}' }
      let(:body_response) { '{}' }

      context 'but do not need to validate' do
        let(:validation_requests) { false }
        let(:validation_response) { false }

        it 'does not return an error' do
          expect { subject }.not_to raise_exception
        end
      end
    end

    context 'request is not documented' do
      let(:request_path) { '/pokemons' }

      it 'does not return an error' do
        expect { subject }.not_to raise_exception
      end

      context 'but be sure to document' do
        let(:skip_not_documented) { false }

        it 'returns an error Request::NotDocumented' do
          expect { subject }.to raise_exception(Fitting::Request::NotDocumented)
        end
      end
    end

    context 'request is not valid' do
      let(:body_request) { '{}' }

      it 'returns an error Request::Unsuitable' do
        expect { subject }.to raise_exception(Fitting::Request::Unsuitable)
      end
    end

    context 'response is not valid ' do
      let(:body_response) { '{}' }

      context 'but do not need to validate' do
        let(:validation_response) { false }

        it 'does not return an error' do
          expect { subject }.not_to raise_exception
        end
      end
    end

    context 'response is not documented' do
      let(:response_status) { '400' }

      context 'but be sure to document' do
        let(:skip_not_documented) { false }

        it 'returns an error Response::NotDocumented' do
          expect { subject }.to raise_exception(Fitting::Response::NotDocumented)
        end
      end
    end

    context 'response is not valid' do
      let(:body_response) { '{}' }

      it 'returns an error Response::Unsuitable' do
        expect { subject }.to raise_exception(Fitting::Response::Unsuitable)
      end
    end

    it 'does not return an error' do
      expect { subject }.not_to raise_exception
    end
  end
end
