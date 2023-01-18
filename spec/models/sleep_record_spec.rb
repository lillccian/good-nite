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
  describe 'validate' do
    let(:user) { create(:user) }
    let(:record) {
      user.sleep_records.new
    }
    let!(:other_record){ create(:sleep_record, user: user) }

    context '#time_comparison_valid' do
      it do
        record.start_at = Time.current
        record.end_at = Time.current

        expect(record.save).to be_falsey
        expect(record.errors).to include(:start_at)
      end
    end

    context '#time_overlap_valid' do
      it do
        record.start_at = other_record.start_at
        record.end_at   = other_record.end_at

        expect(record.save).to be_falsey
        expect(record.errors).to include(:start_at)
        expect(record.errors).to include(:end_at)
      end
    end
  end
end