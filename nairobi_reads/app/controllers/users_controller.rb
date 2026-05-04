class UsersController < ApplicationController
  # SECURITY CHECKS:
  # 1. require_login: Prevents logged-out users from editing/deleting
  # 2. require_admin: Strictly protects the destroy action
  # 3. correct_user_or_admin: Ensures a user can only edit themselves, BUT admins can edit anyone
  before_action :require_login, except: [:new, :create]
  before_action :require_admin, only: [:destroy]
  before_action :correct_user_or_admin, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to Nairobi Reads, #{@user.name}!"
      redirect_to books_path
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    
    # Check if the person updating the profile is an admin.
    # If they are, they get to use admin_user_params (which allows changing the role).
    allowed_params = current_user.admin? ? admin_user_params : user_params

    if @user.update(allowed_params)
      flash[:success] = "Profile updated successfully."
      
      # Smart Redirect: Send admins back to the dashboard, but send normal users to their profile
      if current_user.admin?
        redirect_to admin_dashboard_path(tab: 'users')
      else
        redirect_to user_path(@user)
      end
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    
    # Failsafe: Prevent an admin from accidentally deleting their own account
    if current_user == @user
      flash[:danger] = "You cannot delete your own admin account."
    else
      @user.destroy
      flash[:success] = "User deleted successfully."
    end
    
    # Always send them back to the user list
    redirect_to admin_dashboard_path(tab: 'users')
  end

  private

  # Standard params for regular users (prevents hacking the 'role' field)
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :preferred_meeting_spot)
  end

  # Advanced params for Admins (allows them to change user roles)
  def admin_user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :preferred_meeting_spot, :role)
  end

  # Custom Security Check: Are you editing yourself, or are you an admin?
  def correct_user_or_admin
    @user = User.find(params[:id])
    unless current_user == @user || current_user.admin?
      flash[:danger] = "You do not have permission to do that."
      redirect_to root_path
    end
  end
end