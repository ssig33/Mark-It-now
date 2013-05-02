class AddUserIdOnRecents < ActiveRecord::Migration
  def change
    add_column :recents, :user_id, :string
    add_index :recents, :user_id

    add_column :recent_txts, :user_id, :string
    add_index :recent_txts, :user_id

    add_column :recent_aozoras, :user_id, :string
    add_index :recent_aozoras, :user_id

    Recent.all{|x| x.user_id = 'ssig33'; x.save}
    RecentAozora.all{|x| x.user_id = 'ssig33'; x.save}
    RecentTxt.all{|x| x.user_id = 'ssig33'; x.save}

  end
end
