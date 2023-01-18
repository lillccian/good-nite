require 'rails_helper'

RSpec.describe UserApi::V1::Users do
  let(:token) { create(:access_token) }
  let(:user1) { token.user }
  let(:user2) { create(:user) }
  let(:params) { { access_token: token.token } }

  describe 'user follow' do
    context 'POST /api/v1/users/:id/follow' do
      context 'success' do
        it 'should return 201 and user' do
          expect{
            post "/api/v1/users/#{user2.id}/follow", params: params
          }.to change(user1.followings, :count).by(1)

          result = JSON.parse(response.body)

          expect(response.status).to eq(201)
          expect(result['id']).to eq user2.id
          expect(result['name']).to eq user2.name
        end
        it 'follow twice' do
          expect{
            post "/api/v1/users/#{user2.id}/follow", params: params
            post "/api/v1/users/#{user2.id}/follow", params: params
          }.to change(user1.followings, :count).by(1)

          result = JSON.parse(response.body)

          expect(response.status).to eq(201)
          expect(result['id']).to eq user2.id
          expect(result['name']).to eq user2.name
        end
      end
      context 'failed' do
        it 'following not found' do
          post "/api/v1/users/#{user2.id}123/follow", params: params
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
          post "/api/v1/users/#{user2.id}/unfollow", params: params
        }.to change(user1.followings, :count).by(-1)

        result = JSON.parse(response.body)

        expect(response.status).to eq(201)
        expect(result['data']['success']).to be_truthy
      end
      it 'user not followed, should return 201 and user' do
        post "/api/v1/users/#{user2.id}/unfollow", params: params
        result = JSON.parse(response.body)

        expect(response.status).to eq(201)
        expect(result['data']['success']).to be_truthy
      end
    end
  end
end