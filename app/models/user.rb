class User < ApplicationRecord
 before_save { self.username = username.downcase }
 validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 32 }


 has_secure_password
 validates :password, presence: true, length: { maximum: 32}

 def User.digest(string)
	cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Enginge.cost
	BCrypt::Password.create(string, cost: cost)
 end

 validates :lastEntryTime, presence: true
 validates :defaultCity, presence: true
 validates :defaultSleep, presence: true
 validates :defaultExercise, presence: true

end
