require 'active_record'
require 'logger'
require 'RMagick'
require 'groonga'
require 'zipruby'

module Rails
  def self.root
    File.dirname(__FILE__)
  end
end

database = YAML.load(open(::Rails.root+"/config/database.yml").read)
env = ENV['RAILS_ENV'] || "production"
connection = database[env]

ActiveRecord::Base.establish_connection(connection)
ActiveRecord::Base.logger = Logger.new(STDOUT)

Dir.glob(::Rails.root+"/app/models/*rb").each{|r| require r}

Comic.scan
