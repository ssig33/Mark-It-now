#coding:utf-8
class Comic < ActiveRecord::Base
  require "kconv"
  has_many :pages
  def self.scan
    Dir.glob("#{::Rails.root}/data/**/*.zip").map{|x| x.gsub(/#{::Rails.root}\/data\//, "")}.each{|d| 
      c = Comic.find_by_path(d)
      unless c
        t = Comic.find_or_create_by_path(d, file_type: "zip") 
        t.search_index
        t.scan_page_data
      end
    }
  end

  

  def search_index
    search = Search.new
    if self.path != nil and self.path != "" and self.id != nil
      Groonga["Comics"].add(self.path)
      Groonga["Comics"][self.path].comic_id = self.id.to_s
    end
  end

  def title
    self.path.split("/").last
  end

  def page count
    count = count.to_i-1
    count = 0 if count < 0
    file = nil
    name = self.pages.where(page: count).first.name
    Zip::Archive.open("#{::Rails.root}/data/#{self.path}") do |as|
      as.each_with_index{|a, i|
        if CGI.escape(a.name) == name
          file = a.read
          break
        end
      }
    end
    m = Magick::Image.from_blob(file).first
    x = m.columns
    y = m.rows
    case m.format
    when "JPEG"
      type = 'image/jpeg'
    when "PNG"
      type = 'image/png'
    end
    [m.to_blob, type, (x.to_f/y.to_f > 1.0)]
  end

  def from_name name
    file = nil
    Zip::Archive.open("#{::Rails.root}/data/#{self.path}") do |as|
      as.each_with_index{|a, i|
        if name.toutf8 == name
          file = a.read
          break
        end
      }
    end
    m = Magick::Image.from_blob(file).first
    x = m.columns
    y = m.rows
    case m.format
    when "JPEG"
      type = 'image/jpeg'
    when "PNG"
      type = 'image/png'
    end
    [m.to_blob, type, (x.to_f/y.to_f > 1.0)]
  end


  def max_page
    counter = 0
    Zip::Archive.open("#{::Rails.root}/data/#{self.path}")  do |as|
      as.each_with_index{|a, i|
        if a.name =~ /.png$/ or a.name =~ /.jpg$/ or a.name =~ /.PNG$/ or a.name =~ /.JPG$/ or a.name =~ /.jpeg$/ or a.name =~ /.JPEG$/
          counter+= 1
        end
      }
    end
    counter
  end

  def scan_page_data
    ar = self.files
    if self.pages.size == 0
      count = 0
      Zip::Archive.open("#{::Rails.root}/data/#{self.path}")  do |as|
        as.each_with_index{|a, i|
          if ar.index(a.name)
            m = Magick::Image.from_blob(a.read).first
            case m.format
            when "JPEG"
              type = 'image/jpeg'
            when "PNG"
              type = 'image/png'
            end
            x = m.columns
            y = m.rows
            name = CGI.escape(a.name)
            p name
            Page.find_or_create_by_comic_id_and_page(self.id, ar.index(a.name), {portlait: (x.to_f/y.to_f > 1.0), name: name})
          end
        }
      end
    end
  rescue => e
    p e
  end

  def files
    ar = []
    Zip::Archive.open("#{::Rails.root}/data/#{self.path}")  do |as|
      as.each do |a|
        if a.name =~ /.png$/ or a.name =~ /.jpg$/ or a.name =~ /.PNG$/ or a.name =~ /.JPG$/ or a.name =~ /.jpeg$/ or a.name =~ /.JPEG$/
          ar << a.name
        end
      end
    end
    ar.sort
  end

  def aozora
    str = ""
    Zip::Archive.open("#{::Rails.root}/data/#{self.path}")  do |as|
      as.each do |a|
        if a.name =~ /.txt$/
          str += a.read
        end
      end
    end
    str = str.toutf8
    str = CGI.escapeHTML str
    str.gsub!(/\n/, "<br />")
    str.gsub!(/\r/, "")
    str.gsub!(/｜(.*?)《(.*?)》/, "<ruby><rb>\\1</rb><rt>\\2</rt></ruby>")
    str.gsub!(/(..)《(.*?)》/, "<ruby><rb>\\1</rb><rt>\\2</rt></ruby>")
    str.gsub!(/［＃.*?］/, "")
    str =~/&lt;img src=&quot;(.*)&quot;&gt;/
    str
  end

  def self.search word
    search = Search.new
    result = Groonga['Comics'].select do |record|  
      record.key =~ word
    end
    ids = result.map{|x| x["comic_id"].to_i}.sort
    Comic.where(id: ids)
  end
end
