class Misc
  def password_hash str, salt
    10000.times{str = Digest::SHA1.hexdigest("--#{salt}--#{str}--")}
    str
  end

  def auth password
    p password_hash(password, CONFIG["user"]["salt"])
    p password
    p CONFIG['user']['salt']
    password_hash(password, CONFIG["user"]["salt"]) == CONFIG["user"]["password"]
  end
end
