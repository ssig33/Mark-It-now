class PdfResize
  def self.execute
    prefix = Setting.first.cache_path_prefix
    cs = Comic.where(file_type: 'pdf', pdf_resized: false)
    i = 0
    count = cs.count
    cs.find_each{|x|
      i += 1
      x.pages.includes(:image_cache).each{|p|
        puts "Resize #{x.path} #{p.page.to_i+1}/#{x.pages.count} #{i}/#{count}"
        if p.image_cache and File.exist? File.expand_path([prefix, p.image_cache.name].join('/'))
          path = File.expand_path([prefix, p.image_cache.name].join('/'))
          system "gm mogrify -resize 1024x '#{path}'"
        end
      }
      x.update(pdf_resized: true)
    }
  end
end
