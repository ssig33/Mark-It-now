class AddFileTypeToComic < ActiveRecord::Migration
  def change
    add_column :comics, :file_type, :string
    Comic.all.each{|c| c.update_attributes(file_type: "zip")}
  end
end
