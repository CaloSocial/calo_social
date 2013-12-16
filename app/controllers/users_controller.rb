class UsersController < ApplicationController

  #by default, before filters apply to every action in controller,
  #so here we restrict the filter to act only on the :edit and :update
  #actions
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy


  def index
    @users = User.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def show

    @user = User.find(params[:id]) # it'll return the user id
    if params[:tag]
      @swaps = @user.swaps.tagged_with(params[:tag])
    else
      @swaps = @user.swaps.paginate(page: params[:page])
    end

  	
    @microposts = @user.microposts.paginate(page: params[:page])
    @micropost = Micropost.new #CHECK: is there a better way? 
    
    @swap = Swap.new #CHECK: is there a better way?
  end


  def create
    @user = User.new(user_params) #user params is defined as private (strong)
    if @user.save
    	#user signin after signup
    	sign_in @user
    	redirect_to @user
    	flash[:success] = "Welcome #{@user.name}!"
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end


  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  #Strong parameters. To avoid malicious attacks, permited params should be
  # literally known. It's private, because we didn't want it to be available
  # in Web 

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters


    # def signed_in_user
    #    it is defined in sessions_helper
    # end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
