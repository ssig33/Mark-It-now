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
  
  def self.scan
    array = []
    comics = Dir.glob("#{::Rails.root}/data/**/*.zip").map{|x| x.gsub(/#{::Rails.root}\/data\//, "")}
    Comic.where(path: comics).each{|x| comics.delete x.path}
    comics.each{|d| 
      array << Comic.find_or_create_by(path: d){|x| x.file_type = "zip"}
    }
    comics = Dir.glob("#{::Rails.root}/data/**/*.pdf").map{|x| x.gsub(/#{::Rails.root}\/data\//, "")}
    Comic.where(path: comics).each{|x| comics.delete x.path}
    comics.each{|d| 
      array << Comic.find_or_create_by(path: d){|x| x.file_type = "pdf"}
    }
    array.each_with_index{|a,i|
      a.scan_page_data "#{i+1}/#{array.count}"
      a.create_cache
      a.search_index
    }
    comics = Dir.glob("#{::Rails.root}/data/**/*.txt").map{|x| x.gsub(/#{::Rails.root}\/data\//, "")}
    Comic.where(path: comics).each{|x| comics.delete x.path}
    comics.each{|d| 
      Comic.find_or_create_by(path: d){|x| x.file_type = "txt"}.search_index
    }
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
