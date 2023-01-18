# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  describe 'has_many sleep_records' do
    context 'order by created_at' do
      it do
        record1 = user.sleep_records.create(start_at: 3.day.ago, end_at: 1.day.ago)
        record2 = user.sleep_records.create(start_at: 9.day.ago, end_at: 7.day.ago)
        record3 = user.sleep_records.create(start_at: 6.day.ago, end_at: 4.day.ago)

        expect(user.sleep_records.to_a).to eq( [record1, record2, record3] )
      end
    end
  end
end
