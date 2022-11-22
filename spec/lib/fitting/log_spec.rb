require 'spec_helper'
require 'fitting/log'

RSpec.describe Fitting::Log do
  describe '.all' do
    let(:testlog) { File.read('spec/fixtures/test.log') }

    subject { described_class.all(testlog, 'text') }

    it 'parses path and prefix for provided APIs' do
      expect(subject.first.path).to eq('/sso/oauth2/access_token')
      expect(subject.first.method).to eq('POST')
      expect(subject.first.status).to eq('404')
      expect(subject.first.body).to eq({ 'error' => 'Not found', 'error_description' => 'any error_description' })
      expect(subject.first.host).to eq('kk-sso.test')
      expect(subject[1].path).to eq('/api/v1/profile')
      expect(subject[1].method).to eq('POST')
      expect(subject[1].status).to eq('200')
      expect(subject[1].body).to eq({"status"=>"unauthorized"})
      expect(subject[1].host).to eq('www.example.com')
    end
  end
end
