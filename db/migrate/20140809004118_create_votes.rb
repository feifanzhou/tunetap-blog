class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :post_id
      t.integer :session_id
      t.boolean :is_deleted
      t.boolean :is_upvote

      t.timestamps
    end
  end
end
