#coding:utf-8
module ComicCache
  require 'fileutils'
  def create_cache
    if self.file_type == 'zip' and self.pages.first and self.pages.first.image_cache.nil?
      a = self.pages.order('page asc')
      s = Setting.first
      FileUtils.rm_r "#{Rails.root}/tmp/for_cache" rescue nil
      Dir::mkdir("#{Rails.root}/tmp/for_cache")
      FileUtils.cp self.full_path, "#{Rails.root}/tmp/for_cache"
      files = self.files
      p files
      FileUtils.mkdir("#{s.cache_path_prefix}/#{self.id}") rescue nil
      p_i = 0
      Zip::Archive.open(Dir.glob("#{Rails.root}/tmp/for_cache/*.zip").first) do |stream|
        stream.each do |f|
          name = f.name.toutf8
          if files.index(name)
            f_name = "#{self.id}/"+rand(256**16).to_s(16) + '.' + name.split('.').last
            page = self.pages.where(page: files.index(name)).first
            next unless page
            open("#{s.cache_path_prefix}/#{f_name}", "wb"){|t| t.puts f.read}
            ImageCache.create page_id: page.id, name: f_name
            p_i += 1
            puts "Created Cache #{self.path} Page: #{page.page} #{p_i} / #{self.pages.count}"
          end
        end
      end
      FileUtils.rm_r "#{Rails.root}/tmp/for_cache"
      true
    else
      false
    end
  end
end
