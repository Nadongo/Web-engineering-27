class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      flash[:error] = "Please log in to access this section."
      redirect_to login_path
    end
  end

  def require_admin
    unless logged_in? && current_user.admin?
      flash[:error] = "You must be an administrator to access this section."
      redirect_to books_path
    end
  end
end