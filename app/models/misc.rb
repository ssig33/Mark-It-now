class Misc
  def password_hash str, salt
    10000.times{str = Digest::SHA1.hexdigest("--#{salt}--#{str}--")}
    str
  end

  def auth user, password
    password_hash(password, CONFIG["users"][user]["salt"]) == CONFIG["users"][user]["password"]
  end
end
