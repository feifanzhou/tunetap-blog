class AddIsDeletedToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :is_deleted, :boolean
  end
end
