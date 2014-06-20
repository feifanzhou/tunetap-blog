class CreateTagRanges < ActiveRecord::Migration
  def change
    create_table :tag_ranges do |t|
      t.integer :tagged_text_id
      t.integer :tag_id
      t.integer :start
      t.integer :length

      t.timestamps
    end
    add_index(:tag_ranges, :tagged_text_id)
    add_index(:tag_ranges, :tag_id)
  end
end
