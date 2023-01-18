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
            select users.id, users.name, sum(sleep_records.sleeping_time) as total_time
            from users
            inner join follows on users.id = follows.following_id
            inner join sleep_records on sleep_records.user_id = follows.following_id
            where follows.follower_id = '#{current_user.id}' and
                  sleep_records.start_at > '#{params[:start_at]}'
            group by users.id, users.name
            order by total_time DESC, users.id
          _SQL

          sql_result = ActiveRecord::Base.connection.execute(sql)

          { data: sql_result }
        end
      end
    end
  end
end
