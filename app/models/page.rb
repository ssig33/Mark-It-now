class Page < ActiveRecord::Base
  has_many :recents
  belongs_to :comic
  has_one :image_cache

  def create_cache
    s = Setting.first
    image, type, portlait = self.comic.from_name CGI.unescape(self.name).toutf8
    name = rand(256**16).to_s(16) + '.' + type.split('/').last
    open("#{s.cache_path_prefix}/#{name}", 'wb'){|f| f.puts image}
    ImageCache.create page_id: self.id, name: name
    puts "Created Cache #{self.comic.path} Page: #{self.page}"
    GC.start
  end
  
  def image
    self.comic.page(self.page)
  end
end
