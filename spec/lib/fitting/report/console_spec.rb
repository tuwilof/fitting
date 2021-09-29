require 'spec_helper'
require 'fitting/report/console'

RSpec.describe Fitting::Report::Console do
  describe '#output' do
    let(:tests_without_prefixes) { [] }
    let(:prefixes_details) do
      [
        {
          "name": '/api/v1',
          "actions": {
            "tests_without_actions": [],
            "actions_details": [
              {
                "method": 'POST',
                "path": '/api/v1/book',
                "responses": {
                  "tests_without_responses": [],
                  "responses_details": [
                    {
                      "method": '200',
                      "combinations": {
                        "tests_without_combinations": [],
                        "cover_percent": '100%'
                      }
                    }
                  ]
                }
              },
              {
                "method": 'PATCH',
                "path": '/api/v2/book/{id}',
                "responses": {
                  "tests_without_responses": [],
                  "responses_details": [
                    {
                      "method": '200',
                      "combinations": {
                        "tests_without_combinations": [],
                        "cover_percent": '100%'
                      }
                    }
                  ]
                }
              }
            ]
          }
        },
        {
          "name": '/api/v2',
          "actions": {
            "tests_without_actions": [],
            "actions_details": [
              {
                "method": 'GET',
                "path": '/api/v2/book',
                "responses": {
                  "tests_without_responses": [],
                  "responses_details": [
                    {
                      "method": '200',
                      "combinations": {
                        "tests_without_combinations": [],
                        "cover_percent": '100%'
                      }
                    }
                  ]
                }
              },
              {
                "method": 'DELETE',
                "path": '/api/v2/book/{id}',
                "responses": {
                  "tests_without_responses": [],
                  "responses_details": [
                    {
                      "method": '200',
                      "combinations": {
                        "tests_without_combinations": [],
                        "cover_percent": '100%'
                      }
                    }
                  ]
                }
              }
            ]
          }
        }
      ]
    end

    let(:default) { File.read('spec/fixtures/console/default') }

    subject { described_class.new(tests_without_prefixes, prefixes_details) }

    it do
      expect(subject.output).to eq(default)
    end
  end
end
