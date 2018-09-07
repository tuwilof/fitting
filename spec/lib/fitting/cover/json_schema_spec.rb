require 'spec_helper'
require 'fitting/cover/json_schema'
require 'json'

RSpec.describe Fitting::Cover::JSONSchema do
  let(:json_schema) { {
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
  } }

  subject { described_class.new(json_schema) }

  describe '.new' do
    it 'returns described class object' do
      expect(subject).to be_a(described_class)
    end
  end

  describe '#json_schemas' do
    let(:json_schemas) { [json_schema_two, json_schema_three] }
    let(:json_schema_two) { {
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
    } }
    let(:json_schema_three) { {
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
    } }

    it 'returns json-schemas' do
      expect(subject.json_schemas).to eq(json_schemas)
    end

    context 'attachments' do
      let(:main_json) do
        {
          '$schema' => 'http://json-schema.org/draft-04/schema#',
          'type' => 'object',
          'required' => %w[result]
        }
      end
      let(:login_password) do
        {
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
      end
      let(:json_schema) { main_json.merge('properties' => {'result' => login_password}) }
      let(:json_schema_two) do
        main_json.merge('properties' => {'result' => login_password.merge('required' => %w[login])})
      end
      let(:json_schema_three) do
        main_json.merge('properties' => {'result' => login_password.merge('required' => %w[password])})
      end

      it 'returns json-schemas' do
        expect(subject.json_schemas).to eq([json_schema_two, json_schema_three])
      end

      context 'array' do
        let(:result) do
          {
            'type' => 'array'
          }
        end
        let(:json_schema) do
          main_json.merge(
            'properties' => {'result' => result.merge('items' => login_password)}
          )
        end
        let(:json_schema_two) do
          main_json.merge(
            'properties' => {'result' => result.merge('items' => login_password.merge('required' => %w[login]))}
          )
        end
        let(:json_schema_three) do
          main_json.merge(
            'properties' => {'result' => result.merge('items' => login_password.merge('required' => %w[password]))}
          )
        end

        it 'returns json-schemas' do
          expect(subject.json_schemas).to eq([json_schema_two, json_schema_three])
        end

        context 'together' do
          let(:main_json) do
            {
              '$schema' => 'http://json-schema.org/draft-04/schema#',
              'type' => 'object',
              'required' => %w[status result]
            }
          end
          let(:result) do
            {
              'type' => 'array'
            }
          end
          let(:status) do
            {
              'type' => 'string',
              'enum' => [
                'ok'
              ]
            }
          end
          let(:json_schema) do
            main_json.merge(
              'properties' => {'status' => status, 'result' => result.merge('items' => login_password)}
            )
          end
          let(:json_schema_two) do
            main_json.merge(
              'properties' => {
                'status' => status,
                'result' => result.merge('items' => login_password.merge('required' => %w[login]))
              }
            )
          end
          let(:json_schema_three) do
            main_json.merge(
              'properties' => {
                'status' => status,
                'result' => result.merge('items' => login_password.merge('required' => %w[password]))
              }
            )
          end

          it 'returns json-schemas' do
            expect(subject.json_schemas).to eq([json_schema_two, json_schema_three])
          end
        end
      end
    end
  end

  describe '#combinations' do
    let(:json_schemas) { [json_schema_two, json_schema_three] }
    let(:json_schema_two) { {
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
    } }
    let(:json_schema_three) { {
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
    } }

    it 'returns combinations' do
      expect(subject.combinations).to eq([%w[required captcha], %w[required code]])
    end

    context 'attachments' do
      let(:main_json) do
        {
          '$schema' => 'http://json-schema.org/draft-04/schema#',
          'type' => 'object',
          'required' => %w[result]
        }
      end
      let(:result) do
        {
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
      end
      let(:json_schema) { main_json.merge('properties' => {'result' => result}) }

      it 'returns combinations' do
        expect(subject.combinations).to eq([%w[required login], %w[required password]])
      end
    end
  end
end
