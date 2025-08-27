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

        it 'should return data' do
          auth_user_api_request :get, '/api/v1/followings/sleeping_time'
          result = JSON.parse(response.body)['data']

          expect(result.count).to eq SleepRecord.count
          expect(result.map{ |r| r['id'] }).to eq SleepRecord.all.reorder(sleeping_time: :desc).pluck(:id)
        end
        it 'should return followings users data' do
          Follow.delete_all

          auth_user_api_request :get, '/api/v1/followings/sleeping_time'
          result = JSON.parse(response.body)['data']

          expect(result.count).to eq 0
        end
        it 'should return data with pagination' do
          auth_user_api_request :get, '/api/v1/followings/sleeping_time', params: { page: 2, per_page: 1 }
          result = JSON.parse(response.body)
          data = result['data']

          expect(data.count).to eq 1
          expect(data[0]['id']).to eq SleepRecord.reorder('sleeping_time desc')[1].id
          expect(result['pagination']['current_page']).to eq 2
          expect(result['pagination']['per_page']).to eq 1
          expect(result['pagination']['total_count']).to eq SleepRecord.count
          expect(result['pagination']['total_pages']).to eq SleepRecord.count
        end
        it 'only calculate pass week' do
          auth_user_api_request :get, '/api/v1/followings/sleeping_time'
          result1 = JSON.parse(response.body)['data']

          expect(result1.count).to eq SleepRecord.count
          expect(result1.map{ |r| r['id'] }).to eq SleepRecord.all.reorder(sleeping_time: :desc).pluck(:id)

          random_user = User.order('RANDOM()').first
          old_record = random_user.sleep_records.create(start_at: 20.days.ago, end_at: 10.days.ago)

          auth_user_api_request :get, '/api/v1/followings/sleeping_time'
          result2 = JSON.parse(response.body)['data']

          expect(result2.map{ |r| r['id'] }).to_not include old_record.id
        end
      end
    end
  end
end