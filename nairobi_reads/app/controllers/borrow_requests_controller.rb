class BorrowRequestsController < ApplicationController
  before_action :require_login

  def new
    @book = Book.find(params[:book_id])
    @request = BorrowRequest.new
    
    # Security redirect if they try to borrow their own book
    if @book.owner == current_user
      flash[:error] = "You cannot borrow your own book!"
      redirect_to @book
    end
  end

  def create
    @book = Book.find(params[:borrow_request][:book_id])
    
    if current_user.borrow_requests.exists?(book: @book, status: 'pending')
      flash[:warning] = "You already have a pending request for this book."
      redirect_to @book and return
    end

    @request = current_user.borrow_requests.build(request_params)
    @request.book = @book

    if @request.save
      flash[:success] = "Borrow request sent to #{@book.owner.name}!"
      redirect_to my_bookshelf_path
    else
      flash[:error] = "Unable to send request. Please ensure all fields are filled."
      render :new
    end
  end

  def update
    @request = BorrowRequest.find(params[:id])
    
    unless current_user == @request.book.owner || current_user.admin?
      flash[:error] = "You are not authorized to perform this action."
      redirect_to books_path and return
    end

    if params[:status] == 'approved'
      @request.update(status: 'approved')
      @request.book.update(status: :borrowed)
      flash[:success] = "Request Approved. A notification has been sent to #{@request.requester.name} to meet at your designated location."
    elsif params[:status] == 'rejected'
      @request.update(status: 'rejected')
      flash[:warning] = "Request Declined. #{@request.requester.name} has been notified of the status update."
    end
    
    if current_user.admin?
      redirect_to admin_dashboard_path(tab: 'requests')
    else
      redirect_to my_bookshelf_path
    end
  end

  # ==========================================
  # NEW: RETURN AND REVIEW METHODS
  # ==========================================

  def return_book
    @request = BorrowRequest.find(params[:id])
    
    # Only the owner can mark it returned
    unless current_user == @request.book.owner
      flash[:error] = "Only the book owner can mark this as returned."
      redirect_to my_bookshelf_path and return
    end
    
    @review = Review.new
  end

  def mark_returned
    @request = BorrowRequest.find(params[:id])
    
    # 1. Update the Book and Request statuses
    @request.update(status: 'returned')
    @request.book.update(status: :available)

    # 2. Create the Review
    @review = Review.new(
      rating: params[:review][:rating],
      comment: params[:review][:comment],
      borrow_request: @request,
      reviewer: current_user,
      reviewee: @request.requester
    )

    if @review.save
      flash[:success] = "Book returned successfully! Your review has been added to #{@request.requester.name}'s public profile."
    else
      flash[:warning] = "Book marked as returned, but there was an error saving your review."
    end
    
    redirect_to my_bookshelf_path
  end

  private

  def request_params
    params.require(:borrow_request).permit(:proposed_datetime, :message)
  end
end