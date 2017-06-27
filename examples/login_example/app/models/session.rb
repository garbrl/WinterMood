
require "digest/sha2"

class Session < ApplicationRecord


  def self.create_new_session(username, password)
    
    key = (Digest::SHA2.new << (username + password + DateTime.now.to_s)).to_s
    session = Session::new()
    
    session.username = username
    session.session_key = key
    
    session.save()
    
    return key
  end

  def self.remove_session(username)
    
    conformant = Session::where(username: username)
    if (conformant.size == 0)
      return false
    else
      conformant[0].destroy()
      return true
    end
    
  end
  
  def self.session_is_valid?(username, key)
    
    conformant = Session::where(username: username, session_key: key)
    return conformant.size != 0
    
  end
  

end
