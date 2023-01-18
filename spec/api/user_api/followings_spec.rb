require 'rails_helper'

RSpec.describe UserApi::V1::Followings do
  let!(:user) { @current_user = create(:user) }

  describe 'user following' do
    context 'GET /sleeping_time' do
      context 'success' do
        before{
          3.times do
            new_user = create(:user)
            user.followings << new_user

            rand(1..5).times do |i|
              start_at = i.day.ago
              end_at   = start_at + rand(1..1000).minutes
              new_user.sleep_records.create(start_at: start_at, end_at: end_at)
            end
          end
        }

        it 'should return 201 and data' do
          auth_user_api_request :get, '/api/v1/followings/sleeping_time'
          result = JSON.parse(response.body)

          data = user.followings.map{|u| { 'id' => u.id, 'name' => u.name, 'total_time' => u.sleep_records.sum(:sleeping_time)} }.sort_by{|data| data['total_time']}.reverse

          expect(result['data']).to eq data

          last_user = User.find result['data'][-1]['id']
          last_user.sleep_records.create(start_at: 10.days.ago, end_at: 9.days.ago)
        end
        it 'only calculate pass week' do
          auth_user_api_request :get, '/api/v1/followings/sleeping_time'
          result1 = JSON.parse(response.body)

          last_user = User.find result1['data'][-1]['id']
          last_user.sleep_records.create(start_at: 20.days.ago, end_at: 10.days.ago)

          auth_user_api_request :get, '/api/v1/followings/sleeping_time'
          result2 = JSON.parse(response.body)

          expect(result1['data']).to eq result2['data']
        end
      end
    end
  end
end