module ComicPDF
  def pdf?
    self.file_type == 'pdf'
  end

  def scan_page_data_pdf *args
    return true if self.pages.count > 0
    dir = "#{Rails.root}/tmp/pdf/#{self.id}"
    FileUtils.mkdir_p dir
    FileUtils.cd dir
    p system("gs", "-dSAFER", "-dBATCH", "-dNOPAUSE", "-sDEVICE=jpeg", "-r300", "-dTextAlphaBits=4", "-dGraphicsAlphaBits=4", "-dMaxStripSize=8192", "-sOutputFile=%d.jpg", self.full_path)
    Dir.glob("*.jpg").each{|x|
      i = x.to_i
      if i < 10
        FileUtils.mv x, "000#{i}.jpg"
      elsif i < 100
        FileUtils.mv x, "00#{i}.jpg"
      elsif i < 1000
        FileUtils.mv x, "0#{i}.jpg"
      end
    }
    setting = Setting.first
    all = Dir.glob("*.jpg")
    Dir.glob("*.jpg").sort.each_with_index{|x, page|
      p = Page.find_or_create_by(comic_id: self.id, page: page){|t|
        m = Magick::Image.from_blob(open(x).read).first
        t.portlait = (m.columns.to_f / m.rows.to_f) > 1.0
        t.name = 'pdf'
      }
      cache_path = "#{setting.cache_path_prefix}/#{self.id}"
      FileUtils.mkdir_p cache_path
      cache_name = "#{self.id}/#{rand(256**16).to_s(16)}.jpg"
      FileUtils.mv x, "#{setting.cache_path_prefix}/#{cache_name}"
      ImageCache.create page_id: p.id, name: cache_name
      puts "Created Cache #{self.path} Page: #{p.page+1} / #{all.count}"
    }
    FileUtils.cd Rails.root
    FileUtils.rm_r dir
  end
end
