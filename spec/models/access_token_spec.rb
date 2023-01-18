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
require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
