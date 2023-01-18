# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  has_many :access_tokens
  has_many :sleep_records, -> { order(:created_at) }

  # follower
  has_many :followed_follows, class_name: 'Follow', foreign_key: :following_id, inverse_of: :following, dependent: :delete_all
  has_many :followers, class_name: 'User', through: :followed_follows, source: :follower

  # following
  has_many :follows, class_name: 'Follow', foreign_key: :follower_id, inverse_of: :follower, dependent: :delete_all
  has_many :followings, class_name: 'User', through: :follows, source: :following
end
