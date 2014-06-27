class AddIsAcceptedToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :is_accepted, :boolean
  end
end
