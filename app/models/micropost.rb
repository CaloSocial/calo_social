class Micropost < ActiveRecord::Base
	belongs_to :user
	#DESC is SQL for "descending"
	# scopes take an anonymous function that returns the criteria
	# desired for the scope. In this case order('...').
	#It is a lambda.
	default_scope -> { order('created_at DESC') }
	#Each micropost should have a user id
	validates :user_id, presence: true
	validates :content, presence: true, length: { maximum: 140 }

#We use SQL subselect for scaling. For bigger sites, it would
#be necessary to generate the feed asynchronously
	def self.from_users_followed_by(user)
		followed_user_ids = "SELECT followed_id FROM relationships
												WHERE follower_id = :user_id"
		where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
					user_id: user)
	end
end
