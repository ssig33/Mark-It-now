class CreateRecents < ActiveRecord::Migration
  def change
    create_table :recents do |t|
     t.integer :page_id
     t.timestamps
    end
    add_index :recents, :page_id
  end
end
