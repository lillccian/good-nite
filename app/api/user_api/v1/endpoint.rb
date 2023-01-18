module UserApi
  module V1
    class Endpoint < Grape::API
      version 'v1', using: :path
      format :json

      desc '用來測試服務是否活著'
      get :ping do
        { data: { now: Time.zone.now.iso8601 } }
      end

      route :any, '*path' do
        error!({ message: 'Not Found' }, 404)
      end
    end
  end
end
