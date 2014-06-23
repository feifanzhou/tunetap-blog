class AddIndexToAccessCodeOnInvitations < ActiveRecord::Migration
  def change
    add_index(:invitations, :access_code)
  end
end
