class AddMemoToPages < ActiveRecord::Migration
  def change
    add_column :pages, :memo, :text
  end
end
