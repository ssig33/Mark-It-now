#tcoding:utf-8
module ComicMagick
  def page count
    count = count.to_i-1
    count = 0 if count < 0
    file = nil
    page = self.pages.where(page: count).first
    return page.image_cache.url if page.image_cache
    name = page.name
    Zip::Archive.open(self.full_path) do |as|
      as.each do |a|
        if CGI.escape(a.name.toutf8) == name
          file = a.read
          break
        end
      end
    end
    m = Magick::Image.from_blob(file).first
    x = m.columns
    y = m.rows
    case m.format
    when "JPEG"
      type = 'image/jpeg'
    when "PNG"
      type = 'image/png'
    when "GIF"
      type = 'image/gif'
    end
    r = m.resize_to_fit(1024,1024)
    [r.to_blob, type, (x.to_f/y.to_f > 1.0)]
  end

  def from_name name
    file = nil
    Zip::Archive.open(self.full_path)  do |as|
      as.each do |f|
        if a.name.toutf8 == name
          file = f.read
          break
        end
      end
    end
    if file
      m = Magick::Image.from_blob(file).first
      x = m.columns
      y = m.rows
      case m.format
      when "JPEG"
        type = 'image/jpeg'
      when "PNG"
        type = 'image/png'
      when 'GIF'
        type = 'image/gif'
      end
      r = m.resize_to_fit(1024,1024)
      [r.to_blob, type, (x.to_f/y.to_f > 1.0)]
    end
  end

  def max_page
    self.pages.count
  end

  def scan_page_data *args
    return scan_page_data_pdf(*args) if self.pdf?
    ar = self.files
    if self.pages.size == 0
      Zip::Archive.open(self.full_path)  do |as|
        as.each_with_index do |f,index|
          begin
            name = f.name.toutf8
            if ar.index name
              m = Magick::Image.from_blob(f.read).first
              case m.format
              when "JPEG"
                type = 'image/jpeg'
              when "PNG"
                type = 'image/png'
              when 'GIF'
                type = 'image/gif'
              end
              x = m.columns
              y = m.rows
              c_name = CGI.escape(name)
              puts "#{name} #{index+1}/#{as.count} #{args.first}"
              logger.warn "#{name} #{index+1}/#{as.count} #{args.first}"
              Page.find_or_create_by(comic_id: self.id, page: ar.index(name)){|instance| 
                instance.portlait = (x.to_f/y.to_f > 1.0)
                instance.name = c_name
              }
            end
          rescue =>e 
            puts 'in stream'
            p e
            p e.backtrace
          end
          GC.start
        end
      end
    end
  rescue => e
    puts 'from outerspace'
    p e
    p e.backtrace
  end

  def files
    ar = []
    Zip::Archive.open(self.full_path)  do |as|
      as.each do |a|
        if a.name =~ /.png$/ or a.name =~ /.jpg$/ or a.name =~ /.PNG$/ or a.name =~ /.JPG$/ or a.name =~ /.jpeg$/ or a.name =~ /.JPEG$/ or a.name =~ /.gif$/ or a.name =~ /.GIF$/
          ar << a.name.toutf8
        end
      end
    end
    ar.sort
  end
end
