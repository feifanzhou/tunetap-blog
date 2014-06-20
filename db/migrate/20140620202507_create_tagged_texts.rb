class CreateTaggedTexts < ActiveRecord::Migration
  def change
    create_table :tagged_texts do |t|
      t.string :content_type
      t.text :content
      t.integer :post_id

      t.timestamps
    end
    add_index(:tagged_texts, :post_id)
  end
end
