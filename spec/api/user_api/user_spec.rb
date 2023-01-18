require 'rails_helper'

RSpec.describe UserApi::V1::Users do
  let!(:user1) { @current_user = create(:user) }
  let!(:user2) { create(:user) }

  describe 'user follow' do
    context 'POST /api/v1/users/:id/follow' do
      context 'success' do
        it 'should return 201 and user' do
          expect{
            auth_user_api_request :post, "/api/v1/users/#{user2.id}/follow"
          }.to change(user1.followings, :count).by(1)

          result = JSON.parse(response.body)

          expect(response.status).to eq(201)
          expect(result['id']).to eq user2.id
          expect(result['name']).to eq user2.name
        end
        it 'follow twice' do
          expect{
            auth_user_api_request :post, "/api/v1/users/#{user2.id}/follow"
            auth_user_api_request :post, "/api/v1/users/#{user2.id}/follow"
          }.to change(user1.followings, :count).by(1)

          result = JSON.parse(response.body)

          expect(response.status).to eq(201)
          expect(result['id']).to eq user2.id
          expect(result['name']).to eq user2.name
        end
      end
      context 'failed' do
        it 'following not found' do
          auth_user_api_request :post, "/api/v1/users/#{user2.id}123/follow"
          result = JSON.parse(response.body)

          expect(response.status).to eq(422)
          expect(result['error']).to eq 'follow user error'
        end
      end
    end

    context 'POST /api/v1/users/:id/unfollow' do
      it 'user followed, should return 201 and user' do
        user1.followings << user2

        expect{
          auth_user_api_request :post, "/api/v1/users/#{user2.id}/unfollow"
        }.to change(user1.followings, :count).by(-1)

        result = JSON.parse(response.body)

        expect(response.status).to eq(201)
        expect(result['data']['success']).to be_truthy
      end
      it 'user not followed, should return 201 and user' do
        auth_user_api_request :post, "/api/v1/users/#{user2.id}/unfollow"
        result = JSON.parse(response.body)

        expect(response.status).to eq(201)
        expect(result['data']['success']).to be_truthy
      end
    end
  end
end