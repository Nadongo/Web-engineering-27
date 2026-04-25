require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Trust Engine Calculations" do
    it "correctly calculates the average rating from received reviews" do
      # Setup: Create users
      user = User.create!(name: "Test User", email: "test@example.com", password: "password")
      reviewer = User.create!(name: "Reviewer", email: "reviewer@example.com", password: "password")
      
      # FIX: Create a category first
      category = Category.create!(name: "Fiction")
      
      # FIX: Include category and description in the book
      book = Book.create!(title: "Test Book", author: "Author", description: "A great story.", status: "available", owner: user, category: category)
      
      request1 = BorrowRequest.create!(book: book, requester: reviewer, status: "returned")
      request2 = BorrowRequest.create!(book: book, requester: reviewer, status: "returned")

      Review.create!(rating: 5, comment: "Great!", borrow_request: request1, reviewer: reviewer, reviewee: user)
      Review.create!(rating: 3, comment: "Okay", borrow_request: request2, reviewer: reviewer, reviewee: user)

      expect(user.average_rating).to eq(4.0)
    end

    it "returns 0 if the user has no reviews" do
      new_user = User.create!(name: "New User", email: "new@example.com", password: "password")
      expect(new_user.average_rating).to eq(0)
    end
  end
end