require 'spec_helper'

RSpec.describe Fitting::Response do
  let(:env_response) { double(request: nil, status: nil, body: nil) }
  let(:tomogram) { double(find_request: nil) }
  let(:request) { double(schemas_of_possible_responses: nil) }

  subject { described_class.new(env_response, tomogram) }

  before do
    allow(Fitting::Request).to receive(:new).and_return(request)
  end

  describe '.new' do
    it 'returns described class object' do
      expect(subject).to be_a(described_class)
    end
  end

  describe '#set_fully_validate' do
    before do
      subject.instance_variable_set(:@schemas, ['first_old_schema'])
      allow(JSON::Validator).to receive(:fully_validate).and_return('fully_validate')
    end

    it 'returns fully validate' do
      expect(subject.set_fully_validate).to eq(['fully_validate'])
    end
  end

  describe '#documented?' do
    it 'returns false' do
      expect(subject.documented?).to be_falsey
    end
  end

  describe '#valid??' do
    it 'returns false' do
      expect(subject.valid?).to be_falsey
    end
  end

  describe '#route' do
    before do
      subject.instance_variable_set(:@request, double(route: 'method path'))
      subject.instance_variable_set(:@status, 'status')
      subject.instance_variable_set(:@schemas, ['first_schema'])
      subject.instance_variable_set(:@fully_validates, {0 => []})
    end

    it 'returns route' do
      expect(subject.route).to eq('method path status 0')
    end
  end

  describe '#real_request_with_status' do
    before do
      subject.instance_variable_set(:@request, double(real_method_with_path: 'method path'))
      subject.instance_variable_set(:@status, 'status')
    end

    it 'returns real request with status' do
      expect(subject.real_request_with_status).to eq('method path status')
    end
  end

  describe '#got' do
    let(:body) { double }

    before { subject.instance_variable_set(:@body, body) }

    it 'returns body' do
      expect(subject.got).to eq(body)
    end
  end

  describe '#diff' do
    before { subject.instance_variable_set(:@fully_validates, ['fully validate']) }

    it 'returns diff' do
      expect(subject.diff).to eq("fully validate\n")
    end
  end

  describe '#expected' do
    before { subject.instance_variable_set(:@schemas, ['schema']) }

    it 'returns expected' do
      expect(subject.expected).to eq("schema\n")
    end
  end
end
