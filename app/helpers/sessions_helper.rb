module SessionsHelper

	# def sign_in(user)
	# 	remember_token = User.new_remember_token
	# 	cookies.permanent[:remember_token] = remember_token
	# 	#this method allows to update a single attribute
	# 	user.update_attribute(:remember_token, User.encrypt(remember_token))
	# 	self.current_user = user
	# end

	def signed_in?
		!current_user.nil?
	end

	#define eq in user. Ruby lets us use current_user=() as current_user = 
	# def current_user=(user)
	# 	@current_user = user
	# end

	# def current_user
	# 	remember_token = User.encrypt(cookies[:remember_token])
	# 	@current_user ||= User.find_by(remember_token: remember_token)
	# end

	def current_user?(user)
		user == current_user
	end

	def current_user_ip
		request.ip
	end

	def signed_in_user
		unless user_signed_in?
			store_location
			redirect_to new_user_session_path, notice: "Please sign in." 
		end
	end

	# def sign_out
	# 	#when user signout, the current user is set to nil
	# 	#and the cookie is deleted
	# 	self.current_user = nil
	# 	cookies.delete(:remember_token)
	# end

	# def redirect_back_or(default)
	# 	redirect_to(session[:return_to] || default)
	# 	session.delete(:return_to)
	# end

	def store_location
		#Store target location (only if request=get). (For example, if user request a page but
		# it's not signed in. It remembers the request)
		session[:return_to] = request.url if request.get?
	end
end
