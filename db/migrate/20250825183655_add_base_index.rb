class AddBaseIndex < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_index :follows, :follower_id
    add_index :follows, :following_id

    add_index :sleep_records, [:user_id, :created_at],
              order: { created_at: :asc },
              name: 'idx_sleep_user_created_desc_cover'

    add_index :sleep_records, [:user_id, :start_at, :sleeping_time],
              order: { sleeping_time: :desc },
              name: 'idx_sleep_user_start_len_desc_cover'
  end
end