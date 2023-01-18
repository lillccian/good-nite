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
class AccessToken < ApplicationRecord
  belongs_to :user

  before_create :generate_token

  private

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless AccessToken.exists?(token: random_token)
    end
  end
end
