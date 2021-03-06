class User < ActiveRecord::Base
	# attr email, name, points

	before_save { self.email = email.downcase }
	before_create :create_remember_token

	attr_accessible :email, :name, :password, :password_confirmation, :daily, :today_steps

	has_many :competitions, dependent: :destroy
  has_many :attendees, :dependent => :destroy
  has_many :competitions, :through => :attendees

  has_one :device

	validates :name, presence: true, length: { maximum: 50 }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

	has_secure_password
	validates :password, length: { minimum: 6 }

  serialize :daily, Array


  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end