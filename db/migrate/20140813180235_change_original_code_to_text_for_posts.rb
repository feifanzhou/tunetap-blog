class ChangeOriginalCodeToTextForPosts < ActiveRecord::Migration
  def change
    change_column :posts, :original_code, :text
  end
end
