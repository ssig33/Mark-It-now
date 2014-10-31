class PdfResize < ActiveRecord::Migration
  def change
    add_column :comics, :pdf_resized, :boolean, default: false
  end
end
