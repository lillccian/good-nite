require 'rails_helper'

RSpec.describe UserApi::V1::SleepRecords do
  let(:now) { Time.current }
  let!(:user) { @current_user = create(:user) }
  let(:other_user) { create(:user) }

  before{ Timecop.freeze now }

  context 'without authenticate!' do
    it 'should return 401 and error' do
      user_api_request :get, '/api/v1/sleep_records/ping'
      result = JSON.parse(response.body)

      expect(response.status).to eq(401)
      expect(result['error']['message']).to eq('Authorization failed')
    end
  end

  describe 'sleep_records api' do
    let(:params) { {} }
    let(:records) { create_list(:sleep_record, 3, user: user) }
    let(:record) { records.last }

    context 'get /api/v1/sleep_records' do
      context 'success' do
        it 'get records data, but empty' do
          auth_user_api_request :get, '/api/v1/sleep_records'
          result = JSON.parse(response.body)['data']

          expect(response.status).to eq(200)
        end
        it 'get records data' do
          records
          auth_user_api_request :get, '/api/v1/sleep_records'
          result = JSON.parse(response.body)
          data = result['data']

          expect(response.status).to eq(200)

          expect(data[0]['id']).to eq SleepRecord.first.id
          expect(data[0]['user']['id']).to eq user.id
          expect(data[0]['start_at']).to eq SleepRecord.first.start_at.iso8601
          expect(data[0]['end_at']).to eq SleepRecord.first.end_at.iso8601
          expect(data[0]['sleeping_time']).to eq SleepRecord.first.sleeping_time

          expect(result['pagination']['current_page']).to eq 1
          expect(result['pagination']['per_page']).to eq 50
          expect(result['pagination']['total_pages']).to eq 1
          expect(result['pagination']['total_count']).to eq SleepRecord.count
        end
        it 'get records data with pagination' do
          records
          auth_user_api_request :get, '/api/v1/sleep_records', params: { page: 3,  per_page: 1 }
          result = JSON.parse(response.body)
          data = result['data']

          expect(response.status).to eq(200)

          expect(data[0]['id']).to eq SleepRecord.last.id

          expect(result['pagination']['current_page']).to eq 3
          expect(result['pagination']['per_page']).to eq 1
          expect(result['pagination']['total_pages']).to eq SleepRecord.count
          expect(result['pagination']['total_count']).to eq SleepRecord.count
        end
      end
    end

    context 'get /api/v1/sleep_records/:id' do
      context 'success' do
        it 'get record data' do
          auth_user_api_request :get, "/api/v1/sleep_records/#{record.id}"
          result = JSON.parse(response.body)

          expect(response.status).to eq(200)
          expect(result['id']).to eq record.id
          expect(result['user']['id']).to eq user.id
          expect(result['start_at']).to eq record.start_at.iso8601
          expect(result['end_at']).to eq record.end_at.iso8601
          expect(result['sleeping_time']).to eq record.sleeping_time
        end
      end
      context 'failed' do
        it 'record not found' do
          auth_user_api_request :get, "/api/v1/sleep_records/#{record.id}123"
          result = JSON.parse(response.body)

          expect(response.status).to eq(404)
          expect(result['error']).to eq '404 Not found'
        end
      end
    end

    context 'post /api/v1/sleep_records' do
      subject { auth_user_api_request :post, '/api/v1/sleep_records', params: params }

      context 'success' do
        before{
          params[:start_at] = 1.day.ago
          params[:end_at]   = Time.current

          new_record = create(:sleep_record, user: user)
        }
        it 'return 201, one record create' do
          expect{
            subject
          }.to change(SleepRecord, :count).by(1)

          expect(response.status).to eq(201)
        end
        it 'create new record, return data with pagination' do
          subject
          result = JSON.parse(response.body)
          data = result['data']
          last_record = data.last

          expect(result.count).to eq 2
          expect(last_record['id']).to eq SleepRecord.last.id
          expect(last_record['user']['id']).to eq user.id
          expect(last_record['start_at']).to eq SleepRecord.last.start_at.iso8601
          expect(last_record['end_at']).to eq SleepRecord.last.end_at.iso8601
          expect(last_record['sleeping_time']).to eq SleepRecord.last.sleeping_time

          expect(result['pagination']['current_page']).to eq 1
          expect(result['pagination']['per_page']).to eq 50
          expect(result['pagination']['total_pages']).to eq 1
          expect(result['pagination']['total_count']).to eq SleepRecord.count
        end
        it 'create new record, return data with pagination, current page should be 1' do
          params[:page] = 2
          params[:per_page] = 1

          subject
          result = JSON.parse(response.body)
          data = result['data']
          last_record = data.last

          expect(result.count).to eq 2

          expect(result['pagination']['current_page']).to eq 1
          expect(result['pagination']['per_page']).to eq 1
        end
        it 'overlap other user records' do
          other_user.sleep_records.create(start_at: 3.hours.ago, end_at: 1.hours.ago)

          expect{
            subject
          }.to change(SleepRecord, :count).by(1)

          expect(response.status).to eq(201)
        end
      end

      context 'failed' do
        it 'no record create' do
          expect{
            subject
          }.to_not change{ SleepRecord.count }
        end
        it 'when params missing' do
          params[:start_at] = 1.day.ago

          subject
          result = JSON.parse(response.body)
          expect(response.status).to eq(400)
          expect(result['error']).to eq 'end_at is missing'
        end
        it 'when params invalid' do
          params[:start_at] = '2023-01-32T00:00:00Z'
          params[:end_at]   = Time.current

          subject
          result = JSON.parse(response.body)
          expect(response.status).to eq(400)
          expect(result['error']).to eq 'start_at is invalid'
        end
        it 'when time overlap' do
          user.sleep_records.create(start_at: 3.hours.ago, end_at: 1.hours.ago)

          params[:start_at] = 2.hours.ago
          params[:end_at]   = Time.current

          subject
          result = JSON.parse(response.body)
          expect(response.status).to eq(422)
          expect(result['error']).to eq 'sleep record time overlap'
        end
        it 'when save failed' do
          params[:start_at] = Time.current
          params[:end_at]   = 1.hours.ago

          subject
          result = JSON.parse(response.body)
          expect(response.status).to eq(422)
          expect(result['error']).to eq 'sleep record create error'
        end
      end
    end

    context 'put /api/v1/sleep_records/:id' do
      subject { auth_user_api_request :put, "/api/v1/sleep_records/#{record.id}", params: params }
      context 'success' do
        it 'get record data' do
          time = 1.day.ago
          params[:start_at] = time

          subject
          result = JSON.parse(response.body)

          expect(response.status).to eq(200)
          expect(result['id']).to eq record.id
          expect(result['start_at']).to eq time.iso8601
        end
      end
      context 'failed' do
        it 'record not found' do
          auth_user_api_request :put, "/api/v1/sleep_records/#{record.id}123", params: params
          result = JSON.parse(response.body)

          expect(response.status).to eq(404)
          expect(result['error']).to eq '404 Not found'
        end
        it 'when save failed' do
          params[:start_at] = Time.current
          params[:end_at]   = 1.hours.ago

          subject
          result = JSON.parse(response.body)
          expect(response.status).to eq(422)
          expect(result['error']).to eq 'sleep record update error'
        end
      end
    end

    context 'delete /api/v1/sleep_records/:id' do
      context 'success' do
        it 'get response' do
          auth_user_api_request :delete, "/api/v1/sleep_records/#{record.id}"
          result = JSON.parse(response.body)

          expect(response.status).to eq(200)
          expect(result['data']['success']).to be_truthy
        end
      end
      context 'failed' do
        it 'record not found' do
          auth_user_api_request :delete, "/api/v1/sleep_records/#{record.id}123"
          result = JSON.parse(response.body)

          expect(response.status).to eq(404)
          expect(result['error']).to eq '404 Not found'
        end
      end
    end
  end
end