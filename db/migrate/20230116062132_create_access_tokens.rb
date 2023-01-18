class CreateAccessTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :access_tokens do |t|
      t.bigint :user_id
      t.string :token

      t.timestamps
    end
  end
end
