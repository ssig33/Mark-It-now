class ImageCache < ActiveRecord::Base
  require 'fileutils'
  belongs_to :page

  def url
    Setting.first.cache_path_url+self.name
  end

  def clear
    s = Setting.first
    self.page.comic.pages.map{|x| x.image_cache}.each{|c|
       c.id
       FileUtils.rm "#{s.cache_path_prefix}#{c.name}"
       c.destroy
    }
  end
end
