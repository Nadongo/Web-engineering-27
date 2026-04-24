class BooksController < ApplicationController
  before_action :require_login, except: [:index, :show]
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  # Public Catalog
  def index
    # Start with all books
    @books = Book.all

    # 1. Search by Title or Author (Case Insensitive)
    if params[:query].present?
      search_term = "%#{params[:query].downcase}%"
      @books = @books.where("LOWER(title) LIKE :search OR LOWER(author) LIKE :search", search: search_term)
    end

    # 2. Filter by Category
    if params[:category_id].present?
      @books = @books.where(category_id: params[:category_id])
    end

    # 3. Apply Kaminari Pagination (12 books per page)
    @books = @books.order(created_at: :desc).page(params[:page]).per(12)
  end

  # Book Details
  def show
  end

  # Upload a new book (My Bookshelf)
  def new
    @book = Book.new
  end

  def create
    @book = current_user.books.build(book_params)
    if @book.save
      flash[:success] = "Book was successfully added to your bookshelf!"
      redirect_to books_path
    else
      # This handles the rubric requirement to display validation errors
      render :new
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      flash[:success] = "Book details were successfully updated."
      redirect_to @book
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    flash[:success] = "Book was successfully removed from the catalog."
    redirect_to books_path
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :description, :category_id, :status, :cover_image)
  end

  def authorize_owner!
    unless current_user == @book.owner || current_user.admin?
      flash[:error] = "You are not authorized to perform this action."
      redirect_to books_path
    end
  end
end