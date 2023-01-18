# == Schema Information
#
# Table name: follows
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  follower_id  :bigint           not null
#  following_id :bigint           not null
#
# Indexes
#
#  index_follows_on_follower_id_and_following_id  (follower_id,following_id) UNIQUE
#
FactoryBot.define do
  factory :follow do
    
  end
end
