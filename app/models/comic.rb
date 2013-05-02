#coding:utf-8
class Comic < ActiveRecord::Base
  include ComicCache
  include ComicSearch
  include ComicMagick
  include ComicAozora
  require "kconv"
  require 'digest/md5'

  has_many :pages
  
  def self.scan
    array = []
    Dir.glob("#{::Rails.root}/data/**/*.zip").map{|x| x.gsub(/#{::Rails.root}\/data\//, "")}.each{|d| 
      c = Comic.find_by_path(d)
      unless c
        t = Comic.find_or_create_by_path(d, file_type: "zip") 
        array << t
      end
    }
    array.each_with_index{|a,i|
      a.scan_page_data "#{i+1}/#{array.count}"
      a.create_cache
      a.search_index
    }
    Dir.glob("#{::Rails.root}/data/**/*.txt").map{|x| x.gsub(/#{::Rails.root}\/data\//, "")}.each{|d| 
      c = Comic.find_by_path(d)
      unless c
        t = Comic.find_or_create_by_path(d, file_type: "txt") 
        t.search_index
      end
    }
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
      puts "#{i+1} / #{cs.count}"
    }
  end
end
