class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :comic_id
      t.integer :page
      t.boolean :portlait
      t.timestamps
    end
    add_index :pages, :comic_id
    add_index :pages, :page
  end
end
