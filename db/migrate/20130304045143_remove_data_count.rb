class RemoveDataCount < ActiveRecord::Migration
  def up
    remove_column :comics, :data_count
  end

  def down
    add_column :comics, :data_count, :integer, default: 2
  end
end
