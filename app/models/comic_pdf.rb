module ComicPDF
  def pdf?
    self.file_type == 'pdf'
  end

  def scan_page_data_pdf *args
    list = Magick::Image.read("data/#{self.path}")
    list.each{|x|
      p x.read.count
    }
  end
end
