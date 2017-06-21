class User < ApplicationRecord

  def self.user_credentials_valid?(username, password)

    conformant = User::where(username: username, password: password)
    return conformant.size != 0

  end

  def self.user_exists?(username)

    conformant = User::where(username: username)
    return conformant.size != 0

  end
  
  def self.user_create(username, password)
    
    user = User::new
    
    user.username = username
    user.password = password
    
    user.save()
    
  end

end
