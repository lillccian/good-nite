module UserApi
  module V1
    class Followings < Grape::API
      resources :followings do
        before { authenticate! }

        desc 'get followings sleep time'
        params do
          optional :start_at, type: DateTime, default: 1.week.ago.beginning_of_day.iso8601
        end
        get '/sleeping_time' do
          sql = <<~_SQL
            select sleep_records.*
            from sleep_records
            inner join follows on sleep_records.user_id = follows.following_id
            where follows.follower_id = '#{current_user.id}' and
                  sleep_records.start_at >= '#{params[:start_at]}'
            order by sleep_records.sleeping_time DESC, sleep_records.user_id
          _SQL

          records = SleepRecord.find_by_sql(sql)

          present records, with: Entities::SleepRecord
        end
      end
    end
  end
end
