# == Schema Information
#
# Table name: access_tokens
#
#  id         :integer          not null, primary key
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
FactoryBot.define do
  factory :access_token do
    association :user, factory: [:user]
  end
end
