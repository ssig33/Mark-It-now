class AddLeftToComic < ActiveRecord::Migration
  def change
    add_column :comics, :left, :boolean
  end
end
