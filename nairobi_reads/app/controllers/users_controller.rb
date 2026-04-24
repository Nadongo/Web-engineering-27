class UsersController < ApplicationController
  before_action :require_login, only: [:show, :edit, :update, :bookshelf]

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
      render :new
    end
  end

  # Profile Screen
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated successfully."
      redirect_to @user
    else
      render :edit
    end
  end

  # My Bookshelf Screen
  def bookshelf
    @user = current_user
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :preferred_meeting_spot)
  end
end