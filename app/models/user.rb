class User < ActiveRecord::Base
	# attr email, name, points

	before_save { self.email = email.downcase }

  	attr_accessible :email, :name, :password, :password_confirmation

  	has_many :competitions

  	validates :name, presence: true, length: { maximum: 50 }

  	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  	has_secure_password
  	validates :password, length: { minimum: 6 }
end
