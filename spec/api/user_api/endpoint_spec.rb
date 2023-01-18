require 'rails_helper'

RSpec.describe UserApi::V1::Endpoint do
  context 'GET /api/v1/ping' do
    it 'should return 200 and Time' do
      time = Time.current
      Timecop.freeze time
      get '/api/v1/ping'

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['now']).to eq(time.iso8601)
    end
  end
  context 'wrong path' do
    it 'should return 404' do
      get '/api/v1/error_path'

      expect(response.status).to eq(404)
    end
  end
end
