class AddDataCountToComics < ActiveRecord::Migration
  def change
    add_column :comics, :data_count, :integer, default: 1
  end
end
