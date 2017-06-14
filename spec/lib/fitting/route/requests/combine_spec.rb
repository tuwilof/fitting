require 'spec_helper'
require 'fitting/route/requests/combine'

RSpec.describe Fitting::Route::Requests::Combine do
  subject { described_class.new(stat) }

  let(:stat) do
    double(
      to_hash: {
        'GET /sessions' => { 'cover' => [''], 'not_cover' => [], 'all' => ['✔ '], 'cover_ratio' => 100.0 },
        'POST /sessions' => { 'cover' => [''], 'not_cover' => [''], 'all' => ['✔ ', '✖ '], 'cover_ratio' => 50.0 },
        'GET /users' => { 'cover' => [''], 'not_cover' => [], 'all' => ['✔ '], 'cover_ratio' => 100.0 },
        'POST /users' => { 'cover' => [''], 'not_cover' => [''], 'all' => ['✔ ', '✖ '], 'cover_ratio' => 50.0 },
        'DELETE /sessions' => { 'cover' => [], 'not_cover' => [''], 'all' => ['✖ '], 'cover_ratio' => 0.0 },
        'DELETE /users' => { 'cover' => [], 'not_cover' => [''], 'all' => ['✖ '], 'cover_ratio' => 0.0 }
      }
    )
  end

  let(:result) do
    {
      'full cover' => [
        { 'GET /sessions' => { 'cover' => [''], 'not_cover' => [], 'all' => '✔ ' } },
        { 'GET /users' => { 'cover' => [''], 'not_cover' => [], 'all' => '✔ ' } }
      ],
      'partial cover' => [
        { 'POST /sessions' => { 'cover' => [''], 'not_cover' => [''], 'all' => '✖ ' } },
        { 'POST /users' => { 'cover' => [''], 'not_cover' => [''], 'all' => '✖ ' } }
      ],
      'no cover' => [
        { 'DELETE /sessions' => { 'cover' => [], 'not_cover' => [''], 'all' => '✖ ' } },
        { 'DELETE /users' => { 'cover' => [], 'not_cover' => [''], 'all' => '✖ ' } }
      ]
    }
  end

  describe '#to_hash' do
    it 'returns hash' do
      expect(subject.to_hash).to eq(result)
    end
  end
end
