class PagesController < ApplicationController
  def home
    if logged_in?
      redirect_to books_path
    end
  end
end