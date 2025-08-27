module UserApi
  module V1
    class Followings < Grape::API
      resources :followings do
        helpers SharedParamsHelper

        before { authenticate! }

        desc 'get followings sleep time'
        params do
          optional :start_at, type: DateTime, default: 1.week.ago.beginning_of_day.iso8601
          use :pagination
        end
        get '/sleeping_time' do
          records = SleepRecord
                      .joins("INNER JOIN follows ON sleep_records.user_id = follows.following_id")
                      .where(follows: { follower_id: current_user.id })
                      .where('sleep_records.start_at >= ?', params[:start_at])
                      .order(sleeping_time: :desc, user_id: :asc)

          present_with_pagy :data, pagy(records, page: params[:page], items: params[:per_page]), with: Entities::SleepRecord
        end
      end
    end
  end
end
