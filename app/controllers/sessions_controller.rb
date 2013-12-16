# class SessionsController < ApplicationController
# 	def new
#   end

#  def create
#   user = User.find_by(email: params[:session][:email].downcase)
#   #any object other than nil is true. And user.authenticate becomes true
#   #iff the password is correct
#   if user && user.authenticate(params[:session][:password])
#     # When user sign_in, ip_address updates
#     user.update_attributes(:ip_address => "24.232.154.67" )
#     # Sign the user in and redirect to the user's show page.
#     sign_in user
#     redirect_back_or user
#   else
#   	#we use flash.now because we want it to disappear when a new request is done.
#   	#otherwise it stills there...
#     flash.now[:error] = 'Invalid email/password combination' # Not quite right!
#     render 'new'
#   end
# end

#   def destroy
#     #when user logout
#     sign_out
#     redirect_to root_url
#   end
# end
