class UsersController < ApplicationController
	before_filter :authenticate, :only => [:index, :edit, :update]
	before_filter :correct_user, :only => [:edit, :update]
	before_filter :admin_user, :only => :destroy
	before_filter :not_signed_in, :only => [:new, :create]
 
  def new
  	@title = "Sign up"
  	@user = User.new
  end

  def index
  	@title = "All users"
  	@users = User.paginate(:page => params[:page])
  end
  
  def show
  	@user = User.find(params[:id])
  	@title = @user.name
  	@microposts = @user.microposts.paginate(:page => params[:page])
  end
  
  def create 
  	@user = User.new(params[:user])
  	if @user.save
  		sign_in @user 
 		flash[:success] = "Welcome to the Sample App"  	
 		redirect_to @user
   	else
  		@title = "Sign Up"
  		@user.password = ""
  		@user.password_confirmation = ""
  		render 'new'
  	end
  end
  
  def edit
  	@title = "Edit user"
  end
  
  def update 
  	if @user.update_attributes(params[:user])
 		flash[:success] = "Profile updated"  	
 		redirect_to @user
   	else
  		@title = "Edit user"
  		@user.password = ""
  		@user.password_confirmation = ""
  		render 'edit'
  	end
  end
  
  def destroy
  	user = User.find(params[:id])
  	if user.admin?
  	  	flash[:error] = "Administrators can't be deleted."
  		redirect_to users_path
  	else
  		user.destroy
  		flash[:sucess] = "User deleted."
  		redirect_to users_path
  	end
  end
  
  private
  
	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_path) unless current_user?(@user)
	end
	
	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end
	
	def not_signed_in
	  	 if signed_in?
  		   redirect_to current_user
	  	 end
	end
end
