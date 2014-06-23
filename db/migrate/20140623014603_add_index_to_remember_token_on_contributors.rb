class AddIndexToRememberTokenOnContributors < ActiveRecord::Migration
  def change
    add_index(:contributors, :remember_token)
  end
end
