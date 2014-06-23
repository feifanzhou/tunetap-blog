class AddRememberTokenToContributor < ActiveRecord::Migration
  def change
    add_column :contributors, :remember_token, :string
  end
end
