class AddOriginalCodeToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :original_code, :string
  end
end
