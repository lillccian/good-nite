require 'rails_helper'

RSpec.describe UserApi::V1::SleepRecords do
  let(:now) { Time.current }
  let(:token) { create(:access_token) }
  let(:user) { token.user }

  before{ Timecop.freeze now }

  context 'without authenticate!' do
    it 'should return 401 and error' do
      get '/api/v1/sleep_records/ping'
      result = JSON.parse(response.body)

      expect(response.status).to eq(401)
      expect(result['error']['message']).to eq('Authorization failed')
    end
  end
  context 'wrong path' do
    it 'should return 200 and Time' do
      get '/api/v1/sleep_records/ping', params: { access_token: token.token }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['now']).to eq(now.iso8601)
    end
  end
end
