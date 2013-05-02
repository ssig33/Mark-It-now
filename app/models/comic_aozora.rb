#coding:utf-8
module ComicAozora
  def aozora page
    page = page.to_i
    str = ""
    Zip::Archive.open(self.full_path)  do |as|
      as.each do |a|
        if a.name.toutf8 =~ /.txt$/ or a.name.toutf8 =~ /.TXT$/
          str += a.read
        end
      end
    end
    str = str.toutf8
    str = Sanitize.clean(str, :elements => %w{img}, attributes: {'img' => ['src']})
    array = str.split("\n")
    str = array.slice(page.to_i*60, 60).join("\n")
    str.scan(/<img\ .*?>/).each{|s|
      href = "/img_from_name/#{self.id}?name=#{CGI.escape s.scan(/src="(.*?)"/).first.first}"
      str.sub!(/#{s}/, "<img src='#{href}' alt=''><br />")
    }
    str.gsub!(/\n/, "<br />")
    str.gsub!(/\r/, "")
    str.gsub!(/［＃.*?］/, "")
    str =~/&lt;img src=&quot;(.*)&quot;&gt;/
    str
  end
end
