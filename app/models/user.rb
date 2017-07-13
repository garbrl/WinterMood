class User < ApplicationRecord
 before_save { self.username = username.downcase }
 before_save { self.email = email.downcase }
 validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 32 }


 has_secure_password
 validates :password, presence: true, length: { maximum: 32}

 VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
 validates :email, presence: true, length: { maximum: 255 },
                   format: { with: VALID_EMAIL_REGEX },
                   uniqueness: { case_sensitive: false }

 validates :lastEntryTime, presence: true
 validates :defaultCity, presence: true
 validates :defaultSleep, presence: true
 validates :defaultExercise, presence: true

 def User.digest(string)
	cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Enginge.cost
	BCrypt::Password.create(string, cost: cost)
 end

end
