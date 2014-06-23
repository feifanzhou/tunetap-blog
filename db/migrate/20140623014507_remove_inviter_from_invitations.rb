class RemoveInviterFromInvitations < ActiveRecord::Migration
  def change
    remove_column :invitations, :inviter, :string
  end
end
