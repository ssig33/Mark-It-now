class AddNameToPage < ActiveRecord::Migration
  def change
    add_column :pages, :name, :string
  end
end
