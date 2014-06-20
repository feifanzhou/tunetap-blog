class CreateContributors < ActiveRecord::Migration
  def change
    create_table :contributors do |t|
      t.boolean :is_admin
      t.string :name
      t.string :email
      t.string :password_digest

      t.timestamps
    end
    add_index(:contributors, :name)
  end
end
