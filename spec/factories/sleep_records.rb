# == Schema Information
#
# Table name: sleep_records
#
#  id            :integer          not null, primary key
#  end_at        :datetime         not null
#  sleeping_time :integer          default(0), not null
#  start_at      :datetime         not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint
#
# Indexes
#
#  idx_sleep_user_created_desc_cover    (user_id,created_at)
#  idx_sleep_user_start_len_desc_cover  (user_id,start_at,sleeping_time DESC)
#
FactoryBot.define do
  factory :sleep_record do
    association :user, factory: [:user]

    start_at { 10.hours.ago }
    end_at   { 1.hour.ago }
  end
end
