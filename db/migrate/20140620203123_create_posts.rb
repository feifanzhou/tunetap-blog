class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :contributor_id
      t.string :image_url
      t.string :player_embed
      t.string :player_type
      t.string :download_link
      t.string :twitter_text
      t.string :facebook_text

      t.timestamps
    end
    add_index(:posts, :contributor_id)
  end
end
