#coding:utf-8
class Txt
  require 'kconv'
  attr_accessor :t
  def initialize path
    self.t = open(path).read
  end
  
  def page i
    str = self.t
    str = str.toutf8
    str = Sanitize.clean(str)
    array = str.split("\n")
    str = array.slice(i.to_i*60, 60).join("\n")
    str.scan(/<img\ .*?>/).each{|s|
      href = "/img_from_name/#{self.id}?name=#{CGI.escape s.scan(/src="(.*?)"/).first.first}"
      str.sub!(/#{s}/, "<img src='#{href}' alt=''><br />")
    }
    str.gsub!(/\n/, "<br />")
    str.gsub!(/\r/, "")
    str.gsub!(/［＃.*?］/, "")
    str =~/&lt;img src=&quot;(.*)&quot;&gt;/
    str2 = str.dup
    str.gsub!(/｜(.*?)《(.*?)》/, "<ruby><rb>\\1</rb><rt>\\2</rt></ruby>").gsub!(/(..)《(.*?)》/, "<ruby><rb>\\1</rb><rt>\\2</rt></ruby>") rescue str = str2
    str
  end
end
