class CreateImageCaches < ActiveRecord::Migration
  def change
    create_table :image_caches do |t|
      t.integer :page_id
      t.string :name
      t.timestamps
    end
    add_index :image_caches, :page_id
    add_index :image_caches, :created_at
  end
end
