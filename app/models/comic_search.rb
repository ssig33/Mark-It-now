#coding:utf-8
module ComicSearch
  extend ActiveSupport::Concern
  
  def search_key
    Digest::MD5.hexdigest(self.path).to_s
  end

  def search_index
    search = Search.new
    if self.path != nil and self.path != "" and self.id != nil
      Groonga["Comics"].add(self.search_key)
      Groonga["Comics"][self.search_key].book_path = self.path
      Groonga["Comics"][self.search_key].comic_id = self.id.to_s
    end
  end
  
  module ClassMethods
    def search word
      search = Search.new
      query = word.split(" ").map{|x| "book_path:@#{x}"}.join(' + ')
      result = Groonga['Comics'].select do |record|  
        record.match query
      end
      ids = result.map{|x| x["comic_id"].to_i}.sort
      Comic.where(id: ids).order("id desc")
    end

  end
end
