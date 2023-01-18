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
require 'rails_helper'

RSpec.describe SleepRecord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
