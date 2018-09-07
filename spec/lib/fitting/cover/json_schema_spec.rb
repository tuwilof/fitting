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
      expect(subject.json_schemas).to eq([json_schema_two, json_schema_three])
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
          let(:json_schema) do
            {
              '$schema' => 'http://json-schema.org/draft-04/schema#',
              'type' => 'object',
              'required' => %w[status result],
              'properties' => {
                'status' => {
                  'type' => 'string',
                  'enum' => [
                    'ok'
                  ]
                }, 'result' => {
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
                'status' => {
                  'type' => 'string',
                  'enum' => [
                    'ok'
                  ]
                },
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
                'status' => {
                  'type' => 'string',
                  'enum' => [
                    'ok'
                  ]
                },
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

  describe '#required' do
    it do
      expect(subject.required(
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
          }, 'code' => {
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
                }, 'code' => {
                  'type' => 'string'
                }
              },
              'required' => %w[login password captcha]
            },
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
          ],
          [
            %w[required captcha],
            %w[required code]
          ]
        ]
      )
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

  describe '#super_each' do
    it do
      expect(subject.super_each(
        {
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
        {
          'properties' => nil
        },
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
        ],
        {
          '$schema' => 'http://json-schema.org/draft-04/schema#',
          'type' => 'object',
          'properties' => {
            'login' => {
              'type' => 'string'
            }, 'password' => {
              'type' => 'string'
            }, 'captcha' => {
              'type' => 'string'
            }, 'code' => {
              'type' => 'string'
            }
          },
          'required' => %w[login password]
        },
        [%w[required captcha], %w[required code]]
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
          ],
          [%w[required captcha], %w[required code]]
        ]
      )
    end

    it do
      expect(subject.super_each(
        {"result" => {"type" => "object", "properties" => {"login" => {"type" => "string"}, "password" => {"type" => "string"}}}}, {"properties" => nil}, [], {"$schema" => "http://json-schema.org/draft-04/schema#", "type" => "object", "required" => ["result"], "properties" => {"result" => {"type" => "object", "properties" => {"login" => {"type" => "string"}, "password" => {"type" => "string"}}}}}, []
      )).to eq(
        [[{"$schema" => "http://json-schema.org/draft-04/schema#", "type" => "object", "required" => ["result"], "properties" => {"result" => {"type" => "object", "properties" => {"login" => {"type" => "string"}, "password" => {"type" => "string"}}, "required" => ["login"]}}}, {"$schema" => "http://json-schema.org/draft-04/schema#", "type" => "object", "required" => ["result"], "properties" => {"result" => {"type" => "object", "properties" => {"login" => {"type" => "string"}, "password" => {"type" => "string"}}, "required" => ["password"]}}}], [["required", "login"], ["required", "password"]]]
      )
    end
  end

  describe "#new_super_each" do
    it do
      expect(subject.new_super_each(
        {"result" => {"type" => "object", "properties" => {"login" => {"type" => "string"}, "password" => {"type" => "string"}}}},
        {"properties" => nil},
        {"$schema" => "http://json-schema.org/draft-04/schema#", "type" => "object", "required" => ["result"], "properties" => {"result" => {"type" => "object", "properties" => {"login" => {"type" => "string"}, "password" => {"type" => "string"}}}}},
        []
      )).to eq(
        [
          [
            {
              "$schema" => "http://json-schema.org/draft-04/schema#", "type" => "object", "required" => ["result"], "properties" => {"result" => {"type" => "object", "properties" => {"login" => {"type" => "string"}, "password" => {"type" => "string"}}, "required" => ["login"]}}
            },
            ["required", "login"]
          ],
          [
            {
              "$schema" => "http://json-schema.org/draft-04/schema#", "type" => "object", "required" => ["result"], "properties" => {"result" => {"type" => "object", "properties" => {"login" => {"type" => "string"}, "password" => {"type" => "string"}}, "required" => ["password"]}}
            },
            ["required", "password"]
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
            %w[required login]
          ],
          [
            json_schema_three,
            %w[required password]
          ]
        ])
      end
    end
  end
end
