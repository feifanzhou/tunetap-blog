class ChangeDownloadLinkToText < ActiveRecord::Migration
  def up
    change_column :posts, :download_link, :text
  end

  def down
    change_column :posts, :download_link, :string
  end
end
