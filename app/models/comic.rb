#coding:utf-8
class Comic < ActiveRecord::Base
  include ComicCache
  include ComicSearch
  include ComicMagick
  include ComicAozora
  include ComicPDF
  require "kconv"
  require 'digest/md5'

  has_many :pages
  
  def self.scan *path
    array = []

    if path[1]
      limit = path[1]
      path = "#{::Rails.root}/data"
    else
      if path.first
        path = "#{::Rails.root}/data/#{path.first}"
      else
        path = "#{::Rails.root}/data"
      end
      limit = 1000000000000
    end

    paths = []
    ids = Page.select('distinct comic_id').map{|x| x.comic_id}
    Comic.where(id: ids).find_each{|x|
      paths << x.path
    }
    paths.sort!

    puts "Now I have #{paths.count} books"

    comics = Dir.glob("#{path}/**/*.zip").map{|x| x.gsub(/#{::Rails.root}\/data\//, "")}
    comics.each{|d| 
      next if paths.index d
      next if d =~ /^New/
      c = Comic.find_or_create_by(path: d){|x| x.file_type = "zip"}
      array << c if c.pages.count == 0
      break if array.count >= limit
    }
    comics = Dir.glob("#{path}/**/*.pdf").map{|x| x.gsub(/#{::Rails.root}\/data\//, "")}
    comics.each{|d| 
      next if paths.index d
      next if d =~ /^New/
      c = Comic.find_or_create_by(path: d){|x| x.file_type = "pdf"}
      array << c if c.pages.count == 0
      break if array.count >= limit
    }
    puts "Start Your Engine"
    array.each_with_index{|a,i|
      next if a.created_at < Time.now-86400*60
      pid = fork {
        puts "Start Scan #{i+1}/#{array.count} limit:#{limit}"
        a.scan_page_data "#{i+1}/#{array.count} limit:#{limit}"
        a.create_cache
        a.search_index
        return true if i+1 > limit
      }
      puts "Now waiting... #{pid}"
      Process.waitpid2 pid
    }
    comics = Dir.glob("#{path}/**/*.txt").map{|x| x.gsub(/#{::Rails.root}\/data\//, "")}
    Comic.where(path: comics).each{|x| comics.delete x.path}
    comics.each{|d| 
      Comic.find_or_create_by(path: d){|x| x.file_type = "txt"}.search_index
    }
    Comic.search("pdf").select{|x| x.pages.count == 0}.each{|x| x.scan_page_data}
    true
  end

  def title
    self.path.split("/").last
  end
  
  def full_path
    "#{::Rails.root}/data/#{self.path}"
  end

  def rebuild
    self.pages.destroy_all
    self.scan_page_data
    self.search_index
  end

  def check
    self.destroy unless File.exist?(self.full_path)
  end

  def self.reindex
    cs = Comic.all
    cs.each_with_index{|x,i|
      x.search_index
      puts "#{i+1} / #{cs.count}" if i % 100 == 0
    }
  end
end
