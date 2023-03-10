class CreateFollows < ActiveRecord::Migration[6.1]
  def change
    create_table :follows do |t|
      t.bigint :follower_id, null: false
      t.bigint :following_id, null: false
      t.timestamps
    end

    add_index :follows, %i[follower_id following_id], unique: true
  end
end
