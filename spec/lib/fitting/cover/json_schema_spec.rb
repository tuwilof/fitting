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

  describe '#json_schemas' do
    let(:json_schemas) { [json_schema_two, json_schema_three] }
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

    it 'returns json-schemas' do
      expect(subject.json_schemas).to eq(json_schemas)
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

      it 'returns json-schemas' do
        expect(subject.json_schemas).to eq([json_schema_two, json_schema_three])
      end

      context 'array' do
        let(:json_schema) do
          {
            '$schema' => 'http://json-schema.org/draft-04/schema#',
            'type' => 'object',
            'required' => %w[result],
            'properties' => {
              'result' => {
                'type' => 'array',
                'items' => {
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
          }
        end
        let(:json_schema_two) do
          {
            '$schema' => 'http://json-schema.org/draft-04/schema#',
            'type' => 'object',
            'required' => %w[result],
            'properties' => {
              'result' => {
                'type' => 'array',
                'items' => {
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
          }
        end
        let(:json_schema_three) do
          {
            '$schema' => 'http://json-schema.org/draft-04/schema#',
            'type' => 'object',
            'required' => %w[result],
            'properties' => {
              'result' => {
                'type' => 'array',
                'items' => {
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
          }
        end

        it 'returns json-schemas' do
          expect(subject.json_schemas).to eq([json_schema_two, json_schema_three])
        end

        context 'together' do
          let(:status) do
            {
              'type' => 'string',
              'enum' => [
                'ok'
              ]
            }
          end
          let(:json_schema) do
            {
              '$schema' => 'http://json-schema.org/draft-04/schema#',
              'type' => 'object',
              'required' => %w[status result],
              'properties' => {
                'status' => status, 'result' => {
                  'type' => 'array',
                  'items' => {
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
            }
          end
          let(:json_schema_two) do
            {
              '$schema' => 'http://json-schema.org/draft-04/schema#',
              'type' => 'object',
              'required' => %w[status result],
              'properties' => {
                'status' => status,
                'result' => {
                  'type' => 'array',
                  'items' => {
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
            }
          end
          let(:json_schema_three) do
            {
              '$schema' => 'http://json-schema.org/draft-04/schema#',
              'type' => 'object',
              'required' => %w[status result],
              'properties' => {
                'status' => status,
                'result' => {
                  'type' => 'array',
                  'items' => {
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
            }
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
      expect(subject.combinations).to eq([%w[required captcha], %w[required code]])
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

      it 'returns combinations' do
        expect(subject.combinations).to eq([%w[required login], %w[required password]])
      end
    end
  end
end
