class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :access_code
      t.integer :recipient_id
      t.string :inviter
      t.integer :inviter_id

      t.timestamps
    end
  end
end
