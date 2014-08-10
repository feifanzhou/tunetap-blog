class AddIsDeletedToTags < ActiveRecord::Migration
  def change
    add_column :tags, :is_deleted, :boolean
  end
end
