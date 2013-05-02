class CreateRecentAozoras < ActiveRecord::Migration
  def change
    create_table :recent_aozoras do |t|
      t.integer :comic_id
      t.integer :page
      t.timestamps
    end
    add_index :recent_aozoras, :comic_id
  end
end
