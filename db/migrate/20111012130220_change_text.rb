class ChangeText < ActiveRecord::Migration
  def change
    change_column :pages, :name, :text
  end
end
