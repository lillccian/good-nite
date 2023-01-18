class CreateSleepRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :sleep_records do |t|
      t.bigint :user_id
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.integer :sleeping_time, default: 0, null: false

      t.timestamps
    end
  end
end
