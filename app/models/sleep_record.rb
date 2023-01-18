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
class SleepRecord < ApplicationRecord
  belongs_to :user

  validates_presence_of :start_at, :end_at
  validate :time_comparison_valid
  validate :time_overlap_valid

  before_save :update_sleep_time

  scope :overlap, -> (time){ where('? BETWEEN start_at AND end_at', time) }

  private

  def time_comparison_valid
    return unless start_at && end_at

    if start_at >= end_at
      errors.add(:start_at, 'start time should less than end time')
    end
  end

  def time_overlap_valid
    return unless user

    if user.sleep_records.where.not(id: id).overlap(start_at).exists?
      errors.add(:start_at, 'start time overlap other record')
    end
    if user.sleep_records.where.not(id: id).overlap(end_at).exists?
      errors.add(:end_at, 'end time overlap other record')
    end
  end

  def update_sleep_time
    self.sleeping_time = end_at - start_at
  end
end
