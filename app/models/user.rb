class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

   attr_accessor :login

	# I can't access request method from model, cause its a controller thing

	#dependent: :destroy = when destroy user, destroy its microposts
	has_many :microposts, dependent: :destroy
	# users are now identified with the foreign key follower_id
	# we add dependent destroy so when we destroy an user the relatinship get destroyed aswell
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy

	#A user follows many users through the user.followed. We override this
	#to use followed_users instead with "source"
	has_many :followed_users, through: :relationships, source: :followed
	
	#Here we add class_name, otherwise rails will look the class ReverseRelationship
	has_many :reverse_relationships, foreign_key: "followed_id",
																	 class_name: "Relationship",
																	 dependent:  :destroy
	has_many :followers, through: :reverse_relationships, source: :follower

	has_many :swaps, dependent: :destroy
	#before_save callback. 
	#Emails downcase to avoid problems with database
	before_save { self.email = email.downcase }	
	# before_create :create_remember_token

	
	validates :name,  presence: true, length: { maximum: 50 }
	# /i = case insensitive, \A = begining of string, \z = match end of string
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	 					
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  									uniqueness: { case_sensitive: false } 

  	#password:
  	# has_secure_password #It gives a lot of features of passwords
	validates :password, length: { minimum: 6 }


	#Geocode:
	geocoded_by :ip_address,
  	:latitude => :lat, :longitude => :lon

	after_validation :geocode 

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def feed
		# ? ensures that id is properly escaped before being included in the 
		#underlying SQL query (avoid SQL injection)
		# Micropost.where("user_id = ?", id)
		Micropost.from_users_followed_by(self)
	end 

	#this method get the swaps near the ip parameter. Its called from the
	# static_pages_controller
	def swaps_feed(ip)
		Swap.near_ip(ip)
	end

	def following?(other_user)
		relationships.find_by(followed_id: other_user.id)
	end

	def follow!(other_user)
		relationships.create!(followed_id: other_user.id)
	end

	def unfollow!(other_user)
		relationships.find_by(followed_id: other_user.id).destroy!
	end


	def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
  	end
  end


	# private

	# 	# def create_remember_token
	# 	# 	self.remember_token = User.encrypt(User.new_remember_token)
	# 	# end

end