class AdminController < ApplicationController
  before_action :require_login
  before_action :require_admin

  def dashboard
    @tab = params[:tab] || 'summary'

    if @tab == 'summary'
      @total_users = User.count
      @total_books = Book.count
      @active_requests = BorrowRequest.where(status: 'pending').count
      @recent_books = Book.order(created_at: :desc).limit(3)
      @recent_requests = BorrowRequest.order(created_at: :desc).limit(3)
    
    elsif @tab == 'users'
      # Kaminari Pagination: 10 users per page
      @users = User.order(created_at: :desc).page(params[:page]).per(10)
    
    elsif @tab == 'books'
      # Kaminari Pagination: 10 books per page
      @books = Book.order(created_at: :desc).page(params[:page]).per(10)
    
    elsif @tab == 'categories'
      @categories = Category.order(:name)
      @new_category = Category.new
    
    elsif @tab == 'requests'
      @requests = BorrowRequest.where(status: 'pending').order(created_at: :desc)
    end
  end
end