class StaticPagesController < ApplicationController
  def home
  	if signed_in?
      # current_user.update_attributes(:ip_address => request.ip )
      # current_user.ip_address = "24.232.154.67"
      current_user_ip = request.ip
      #Search for the data of current_user_ip
      s = Geocoder.search(current_user_ip)

      @city = s[0].city
      @address = s[0].address
      
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      @swap = current_user.swaps.build
      #We pass the parameter current_user_ip to get the swaps near the user
      @swaps_feed_items = current_user.swaps_feed(current_user_ip).paginate(page: params[:page])
  
    end
  end

  def help
  end

  def about
  end

  def contact
  end
  
end
