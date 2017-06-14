require 'spec_helper'
require 'fitting/route/requests/lists'

RSpec.describe Fitting::Route::Requests::Lists do
  subject do
    described_class.new(double(
                          full_cover: full_cover,
                          partial_cover: partial_cover,
                          no_cover: no_cover,
                          max: max
    ))
  end

  let(:max) { 8 }
  let(:full_cover) { double }
  let(:partial_cover) { double }
  let(:no_cover) { double }

  describe '#fully_implemented' do
    let(:full_cover) do
      [
        { 'GET /sessions' => { 'cover' => [''], 'not_cover' => [], 'all' => '✔' } },
        { 'GET /users' => { 'cover' => [''], 'not_cover' => [], 'all' => '✔' } }
      ]
    end

    it 'returns fully_implemented' do
      expect(subject.fully_implemented).to eq(["GET\t/sessions\t\t\t\t\t\t\t✔", "GET\t/users\t\t\t\t\t\t\t\t✔"])
    end
  end

  describe '#partially_implemented' do
    let(:partial_cover) do
      [
        { 'POST /sessions' => { 'cover' => [''], 'not_cover' => [''], 'all' => '✖' } },
        { 'POST /users' => { 'cover' => [''], 'not_cover' => [''], 'all' => '✖' } }
      ]
    end

    it 'returns partially_implemented' do
      expect(subject.partially_implemented).to eq(["POST\t/sessions\t\t\t\t\t\t\t✖", "POST\t/users\t\t\t\t\t\t\t\t✖"])
    end
  end

  describe '#no_implemented' do
    let(:no_cover) do
      [
        { 'DELETE /sessions' => { 'cover' => [], 'not_cover' => [''], 'all' => '✖' } },
        { 'DELETE /users' => { 'cover' => [], 'not_cover' => [''], 'all' => '✖' } }
      ]
    end

    it 'returns no_implemented' do
      expect(subject.no_implemented).to eq(["DELETE\t/sessions\t\t\t\t\t\t\t✖", "DELETE\t/users\t\t\t\t\t\t\t\t✖"])
    end
  end

  describe '#to_s' do
    before do
      allow(subject).to receive(:fully_implemented).and_return(['FKR'])
      allow(subject).to receive(:partially_implemented).and_return(['PI'])
      allow(subject).to receive(:no_implemented).and_return(['NI'])
    end

    it 'returns conformity lists' do
      expect(subject.to_s).to eq([
        ['Fully conforming requests:', 'FKR'].join("\n"),
        ['Partially conforming requests:', 'PI'].join("\n"),
        ['Non-conforming requests:', 'NI'].join("\n")
      ].join("\n\n"))
    end

    context 'there are empty lists' do
      before do
        allow(subject).to receive(:fully_implemented).and_return(['FKR'])
        allow(subject).to receive(:partially_implemented).and_return([])
        allow(subject).to receive(:no_implemented).and_return([])
      end

      it 'returns conformity lists' do
        expect(subject.to_s).to eq([
          ['Fully conforming requests:', 'FKR'].join("\n")
        ].join("\n\n"))
      end
    end
  end
end
