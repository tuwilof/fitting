require 'spec_helper'
require 'fitting/records/spherical/request'

RSpec.describe Fitting::Records::Spherical::Request do
  let(:json) { "{\"method\":\"GET\",\"path\":\"users\",\"body\":\"{\\\"name\\\": \\\"noname\\\"}\",\"response\":\"{\\\"name\\\": \\\"John\\\"}\",\"title\":\"spec/spec_users.rb:4\",\"group\":\"spec/spec_users.rb\"}" }
  let(:hash) { {"method" => "GET", "path" => "users", "body" => "{\"name\": \"noname\"}", "response" => "{\"name\": \"John\"}", "title" => "spec/spec_users.rb:4", "group" => "spec/spec_users.rb"} }

  describe '#to_json' do
    subject do
      described_class.new(
        method: 'GET',
        path: 'users',
        body: "{\"name\": \"noname\"}",
        response: double(to_hash: "{\"name\": \"John\"}"),
        title: 'spec/spec_users.rb:4',
        group: 'spec/spec_users.rb'
      )
    end
    it 'returns json' do
      expect(subject.to_json).to eq(json)
    end
  end

  describe '#to_hash' do
    subject do
      described_class.new(
        method: 'GET',
        path: 'users',
        body: "{\"name\": \"noname\"}",
        response: double(to_hash: "{\"name\": \"John\"}"),
        title: 'spec/spec_users.rb:4',
        group: 'spec/spec_users.rb'
      )
    end
    it 'returns json' do
      expect(subject.to_hash).to eq({:method => "GET", :path => "users", :body => "{\"name\": \"noname\"}", :response => "{\"name\": \"John\"}", :title => "spec/spec_users.rb:4", :group => "spec/spec_users.rb"})
    end
  end

  describe '#load' do
    subject { described_class.load(hash) }

    it 'returns method' do
      expect(subject.method).to eq('GET')
    end

    it 'returns path' do
      expect(subject.path).to eq("users")
    end

    it 'returns body' do
      expect(subject.body).to eq("{\"name\": \"noname\"}")
    end

    it 'returns response' do
      expect(subject.response).to be_a(Fitting::Records::Spherical::Response)
    end

    it 'returns title' do
      expect(subject.title).to eq('spec/spec_users.rb:4')
    end

    it 'returns group' do
      expect(subject.group).to eq('spec/spec_users.rb')
    end
  end
end
