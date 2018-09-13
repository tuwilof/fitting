require 'spec_helper'
require 'fitting/cover/json_schema'
require 'json'

RSpec.describe Fitting::Cover::JSONSchema do
  let(:json_schema) do
    {
      '$schema' => 'http://json-schema.org/draft-04/schema#',
      'type' => 'object',
      'properties' => {
        'login' => {
          'type' => 'string'
        },
        'password' => {
          'type' => 'string'
        },
        'captcha' => {
          'type' => 'string'
        },
        'code' => {
          'type' => 'string'
        }
      },
      'required' => %w[login password]
    }
  end

  subject { described_class.new(json_schema) }

  describe '.new' do
    it 'returns described class object' do
      expect(subject).to be_a(described_class)
    end
  end

  describe '#new_required' do
    it do
      expect(subject.new_required(
               '$schema' => 'http://json-schema.org/draft-04/schema#',
               'type' => 'object',
               'properties' => {
                 'login' => {
                   'type' => 'string'
                 },
                 'password' => {
                   'type' => 'string'
                 },
                 'captcha' => {
                   'type' => 'string'
                 },
                 'code' => {
                   'type' => 'string'
                 }
               },
               'required' => %w[login password]
      )).to eq(
        [
          [
            {
              '$schema' => 'http://json-schema.org/draft-04/schema#',
              'type' => 'object',
              'properties' => {
                'login' => {
                  'type' => 'string'
                },
                'password' => {
                  'type' => 'string'
                },
                'captcha' => {
                  'type' => 'string'
                },
                'code' => {
                  'type' => 'string'
                }
              },
              'required' => %w[login password captcha]
            },
            %w[required captcha]
          ],
          [
            {
              '$schema' => 'http://json-schema.org/draft-04/schema#',
              'type' => 'object',
              'properties' => {
                'login' => {
                  'type' => 'string'
                },
                'password' => {
                  'type' => 'string'
                },
                'captcha' => {
                  'type' => 'string'
                },
                'code' => {
                  'type' => 'string'
                }
              },
              'required' => %w[login password code]
            },
            %w[required code]
          ]
        ]
      )
    end
  end

  describe '#new_super_each' do
    it do
      expect(subject.new_super_each(
               { 'result' => { 'type' => 'object', 'properties' => { 'login' => { 'type' => 'string' }, 'password' => { 'type' => 'string' } } } },
               { 'properties' => nil },
               { '$schema' => 'http://json-schema.org/draft-04/schema#', 'type' => 'object', 'required' => ['result'], 'properties' => { 'result' => { 'type' => 'object', 'properties' => { 'login' => { 'type' => 'string' }, 'password' => { 'type' => 'string' } } } } },
               [],
        nil
      )).to eq(
        [
          [
            {
              '$schema' => 'http://json-schema.org/draft-04/schema#', 'type' => 'object', 'required' => ['result'], 'properties' => { 'result' => { 'type' => 'object', 'properties' => { 'login' => { 'type' => 'string' }, 'password' => { 'type' => 'string' } }, 'required' => ['login'] } }
            },
            %w[required result.login]
          ],
          [
            {
              '$schema' => 'http://json-schema.org/draft-04/schema#', 'type' => 'object', 'required' => ['result'], 'properties' => { 'result' => { 'type' => 'object', 'properties' => { 'login' => { 'type' => 'string' }, 'password' => { 'type' => 'string' } }, 'required' => ['password'] } }
            },
            %w[required result.password]
          ]
        ]
      )
    end
  end

  describe '#combi' do
    let(:json_schema_two) do
      {
        '$schema' => 'http://json-schema.org/draft-04/schema#',
        'type' => 'object',
        'properties' => {
          'login' => {
            'type' => 'string'
          },
          'password' => {
            'type' => 'string'
          },
          'captcha' => {
            'type' => 'string'
          },
          'code' => {
            'type' => 'string'
          }
        },
        'required' => %w[login password captcha]
      }
    end
    let(:json_schema_three) do
      {
        '$schema' => 'http://json-schema.org/draft-04/schema#',
        'type' => 'object',
        'properties' => {
          'login' => {
            'type' => 'string'
          },
          'password' => {
            'type' => 'string'
          },
          'captcha' => {
            'type' => 'string'
          },
          'code' => {
            'type' => 'string'
          }
        },
        'required' => %w[login password code]
      }
    end

    it 'returns combinations' do
      expect(subject.combi).to eq([
                                    [
                                      json_schema_two,
                                      %w[required captcha]
                                    ],
                                    [
                                      json_schema_three,
                                      %w[required code]
                                    ]
                                  ])
    end

    context 'attachments' do
      let(:json_schema) do
        {
          '$schema' => 'http://json-schema.org/draft-04/schema#',
          'type' => 'object',
          'required' => %w[result],
          'properties' => {
            'result' => {
              'type' => 'object',
              'properties' => {
                'login' => {
                  'type' => 'string'
                },
                'password' => {
                  'type' => 'string'
                }
              }
            }
          }
        }
      end
      let(:json_schema_two) do
        {
          '$schema' => 'http://json-schema.org/draft-04/schema#',
          'type' => 'object',
          'required' => %w[result],
          'properties' => {
            'result' => {
              'type' => 'object',
              'properties' => {
                'login' => {
                  'type' => 'string'
                },
                'password' => {
                  'type' => 'string'
                }
              },
              'required' => %w[login]
            }
          }
        }
      end
      let(:json_schema_three) do
        {
          '$schema' => 'http://json-schema.org/draft-04/schema#',
          'type' => 'object',
          'required' => %w[result],
          'properties' => {
            'result' => {
              'type' => 'object',
              'properties' => {
                'login' => {
                  'type' => 'string'
                },
                'password' => {
                  'type' => 'string'
                }
              },
              'required' => %w[password]
            }
          }
        }
      end

      it 'returns combinations' do
        expect(subject.combi).to eq([
          [
            json_schema_two,
            %w[required properties.result.login]
          ],
          [
            json_schema_three,
            %w[required properties.result.password]
          ]
        ])
      end
    end
  end

  describe "#new_keys" do
    it do
      expect(subject.new_keys(
        {
          '$schema' => 'http://json-schema.org/draft-04/schema#',
          'type' => 'object',
          'properties' => {
            'login' => {
              'type' => 'string'
            },
            'password' => {
              'type' => 'string'
            },
            'captcha' => {
              'type' => 'string'
            },
            'code' => {
              'type' => 'string'
            }
          },
          'required' => %w[login password]
        }
      )).to eq(
        ["captcha", "code"]
      )
    end
  end
end
