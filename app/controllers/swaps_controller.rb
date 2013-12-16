class SwapsController < ApplicationController
	before_action :signed_in_user, only: [:index, :create, :destroy, :update]

	def index
		if (params[:tag])
			@swaps = Swap.tagged_with(params[:tag])
		else
			@swaps = Swap.all
		end

		@search = Swap.search(params[:q])
		@swaps = @search.result

	end

	def nearby
		if (not params.nil?)
			latitude = params[:latitude]
			longitude = params[:longitude]
			@swaps = Swap.near([latitude, longitude], 20)
		else
			@swaps = Swap.all?
		end
	end

	def create
		@swap = current_user.swaps.build(swap_params)
		if @swap.save
			flash[:success] = "Swap created!"
			redirect_to root_path
		else
			@micropost = current_user.microposts.build
			@feed_items = current_user.feed.paginate(page: params[:page])
			@swaps_feed_items = current_user.swaps_feed(current_user_ip).paginate(page: params[:page])
			render 'static_pages/home'
		end
	end

	def destroy
	end

	def update
	end


	private

		def swap_params
			params.require(:swap).permit(:description, :offer, :want, :place, :tag_list)
		end
end
