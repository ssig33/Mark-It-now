class Page < ActiveRecord::Base
  has_many :recents
  belongs_to :comic
end
