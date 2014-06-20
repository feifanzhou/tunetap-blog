class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.text :description
      t.integer :contributor_id

      t.timestamps
    end
    add_index(:tags, :contributor_id)
  end
end
