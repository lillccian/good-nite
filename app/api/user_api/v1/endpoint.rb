module UserApi
  module V1
    class Endpoint < Grape::API
      version 'v1', using: :path
      format :json

      include ExceptionHandlers

      use Auth::Middleware

      helpers Helpers

      desc '用來測試服務是否活著'
      get :ping do
        { data: { now: Time.zone.now.iso8601 } }
      end

      mount SleepRecords
      mount Users
      mount Followings
    end
  end
end
