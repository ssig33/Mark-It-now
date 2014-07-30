class CreateMemos < ActiveRecord::Migration
  def change
    create_table :memos do |t|
      t.integer :page_id
      t.string :user_id
      t.text :body
      t.timestamps
    end
    add_index :memos, [:page_id, :user_id]
  end
end
