module UserApi
  module V1
    class SleepRecords < Grape::API
      resources :sleep_records do
        before { authenticate! }

        desc '用來測試服務是否活著'
        get :ping do
          { data: { now: Time.zone.now.iso8601 } }
        end
      end
    end
  end
end
