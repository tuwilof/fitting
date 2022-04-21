require 'spec_helper'
require 'fitting/doc'

RSpec.describe Fitting::Doc do
  describe '.all' do
    let(:yaml) { YAML.safe_load(File.read('spec/fixtures/.fitting.yml')) }

    subject { described_class.all(yaml) }

    it 'parses path and prefix for provided APIs' do
      expect(subject.first.path).to eq('json_schemas/main_api.json')
      expect(subject.first.prefix).to eq('/api/v1')
      expect(subject[1].path).to eq('json_schemas/admin_api.json')
      expect(subject[1].prefix).to eq('/api/admin')
    end

    it 'parses path and prefix for used APIs' do
      expect(subject[2].path).to eq('json_schemas/tarifficator.json')
      expect(subject[2].host).to eq('tarifficator.local')
      expect(subject[3].path).to eq('json_schemas/sso.json')
      expect(subject[3].host).to eq('sso.local')
    end
  end

  describe '.find' do
    let(:docs) { YAML.safe_load(File.read('spec/fixtures/.fitting.yml')) }

    subject { described_class.find!(docs, log) }

    context 'incoming request' do
      let(:log) do
        '2022-02-22T14:20:37.888049+04:00 - 59698 DEBUG - FITTING incoming request '\
        '{"method":"POST","path":"/api/v1/profile", "body":{"ids":[]},"response":{"status":200,"body":{"status":'\
        '"unauthorized"}},"title":"./spec/support/shared_examples/unauthorized.rb:8","group":'\
        '"./spec/support/shared_examples/unauthorized.rb"}'
      end
    end

    context 'outgoing request' do
      let(:log) do
        '2022-02-22T14:20:37.883550+04:00 - 59696 DEBUG - FITTING outgoing request '\
         '{"method":"POST","path":"/sso/oauth2/access_token","body":{},"response":{"status":404,"body":{"error":'\
         '"Not found","error_description":"any error_description"}},"title":'\
         '"./spec/jobs/sso_create_link_job_spec.rb:93","group":"./spec/jobs/sso_create_link_job_spec.rb"}'
      end
    end
  end
end
