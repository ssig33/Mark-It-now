class Search
  attr_accessor :g
  def initialize
    Dir::mkdir ::Rails.root+"db/groonga" unless File.exist? ::Rails.root+"db/groonga"
    if File.exist? "#{::Rails.root}/db/groonga/search"
      self.g = Groonga::Database.open "#{::Rails.root}/db/groonga/search"
    else
      self.g = Groonga::Database.create path: "#{::Rails.root}/db/groonga/search"
      self.define_schema
    end
  end

  def define_schema
    Groonga::Schema.define do |schema|
      schema.create_table("Comics", type: :patricia_trie, :key_type => "ShortText"){|table| 
        table.text "book_path"
        table.short_text "comic_id"}
      schema.create_table("Terms", type: :patricia_trie, key_type: "ShortText", default_tokenizer: "TokenBigram", key_normalize: true) { |table|  table.index("Comics.book_path") }
    end
  end
end
