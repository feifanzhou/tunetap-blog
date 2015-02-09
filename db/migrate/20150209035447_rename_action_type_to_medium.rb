class RenameActionTypeToMedium < ActiveRecord::Migration
  def change
    rename_column :actions, :type, :medium
  end
end
