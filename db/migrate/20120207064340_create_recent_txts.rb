class CreateRecentTxts < ActiveRecord::Migration
  def change
    create_table :recent_txts do |t|
      t.integer :comic_id
      t.integer :page
      t.timestamps
    end
    add_index :recent_txts, :comic_id
  end
end
