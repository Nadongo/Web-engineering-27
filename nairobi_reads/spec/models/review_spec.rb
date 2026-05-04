require 'rails_helper'

RSpec.describe Review, type: :model do
  # 1. Setup the necessary data chain for a Review to exist
  let(:reviewer) { User.create!(name: "Reviewer", email: "reviewer@test.com", password: "password123", preferred_meeting_spot: "Library") }
  let(:reviewee) { User.create!(name: "Reviewee", email: "reviewee@test.com", password: "password123", preferred_meeting_spot: "Cafe") }
  let(:category) { Category.create!(name: "Fiction") }
  let(:book) { Book.create!(title: "Test Book", author: "Author", description: "Desc", owner: reviewee, category: category) }
  let(:borrow_request) { BorrowRequest.create!(book: book, requester: reviewer, status: :approved) }

  describe "Validations and Negative Tests" do
    it "is valid with a rating, comment, and associations" do
      review = Review.new(
        rating: 5, 
        comment: "Great experience!", 
        borrow_request: borrow_request, 
        reviewer: reviewer, 
        reviewee: reviewee
      )
      expect(review).to be_valid
    end

    it "is invalid without a rating (Negative Test)" do
      review = Review.new(comment: "Great experience!", borrow_request: borrow_request, reviewer: reviewer, reviewee: reviewee)
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include("can't be blank")
    end

    it "is invalid if the rating is outside 1-5 (Negative Test)" do
      review = Review.new(rating: 6, comment: "Too good!", borrow_request: borrow_request, reviewer: reviewer, reviewee: reviewee)
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include("is not included in the list")

      review.rating = 0
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include("is not included in the list")
    end

    it "is invalid without a comment (Negative Test)" do
      review = Review.new(rating: 4, borrow_request: borrow_request, reviewer: reviewer, reviewee: reviewee)
      expect(review).not_to be_valid
      expect(review.errors[:comment]).to include("can't be blank")
    end
  end
end