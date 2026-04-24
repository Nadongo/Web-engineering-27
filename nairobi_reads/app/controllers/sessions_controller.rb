class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = "Logged in successfully."
      redirect_to books_path
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:success] = "Logged out successfully."
    redirect_to root_path
  end

  def guest_login
    guest_user = User.find_or_create_by!(email: 'guest@nairobireads.co.ke') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "Guest User"
      user.role = :general
      user.preferred_meeting_spot = "Any Public Library"
    end
    session[:user_id] = guest_user.id
    flash[:success] = "Logged in as a Guest User."
    redirect_to books_path
  end

  def guest_admin_login
    guest_admin = User.find_or_create_by!(email: 'admin_guest@nairobireads.co.ke') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "Guest Admin"
      user.role = :admin
      user.preferred_meeting_spot = "Admin Office"
    end
    session[:user_id] = guest_admin.id
    flash[:success] = "Logged in as a Guest Administrator."
    redirect_to books_path
  end
end