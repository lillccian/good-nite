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
FactoryBot.define do
  factory :sleep_record do
    association :user, factory: [:user]

    start_at { 10.hours.ago }
    end_at   { 1.hour.ago }
  end
end
