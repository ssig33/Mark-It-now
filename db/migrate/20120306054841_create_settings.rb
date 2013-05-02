class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :cache_path_prefix
      t.string :cache_path_url
      t.timestamps
    end
  end
end
