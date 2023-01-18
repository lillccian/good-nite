module UserApi
  module V1
    class Users < Grape::API
      resources :users do
        before { authenticate! }

        desc 'follow user'
        post '/:id/follow' do
          follow = current_user.follows.find_or_create_by(following_id: params[:id])

          if follow.persisted?
            present follow.following, with: Entities::User
          else
            error!('follow user error', 422)
          end
        end

        desc 'unfollow user'
        post '/:id/unfollow' do
          follow = current_user.follows.find_by(following_id: params[:id])

          if follow.nil?
            return { data: { success: true } }
          end

          if follow.destroy
            { data: { success: true } }
          else
            error!('follow user error', 422)
          end
        end
      end
    end
  end
end
