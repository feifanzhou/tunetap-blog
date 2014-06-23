class AddShouldBeAdminToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :should_be_admin, :boolean
  end
end
