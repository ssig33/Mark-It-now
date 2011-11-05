class CreateComics < ActiveRecord::Migration
  def change
    create_table :comics do |t|
      t.string :path
      t.boolean :aozora
      t.timestamps
    end
    add_index :comics, :path
  end
end
