class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.integer :post_id
      t.integer :count
      t.string :type

      t.timestamps null: false
    end
  end
end
