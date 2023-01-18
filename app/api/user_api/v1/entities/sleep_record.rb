module UserApi
  module V1
    module Entities
      class SleepRecord < Entities::Base
        expose :id
        expose :user_id
        expose :start_at, format_with: :iso8601
        expose :end_at, format_with: :iso8601
        expose :sleeping_time
        expose :created_at, format_with: :iso8601
        expose :updated_at, format_with: :iso8601
      end
    end
  end
end
