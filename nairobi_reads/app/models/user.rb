class User < ApplicationRecord
  has_secure_password

  has_many :books, foreign_key: :owner_id, dependent: :destroy
  
  # Books this user has requested to borrow
  has_many :borrow_requests, foreign_key: :requester_id, dependent: :destroy
  has_many :requested_books, through: :borrow_requests, source: :book
  
  # Requests made to this user's books
  has_many :received_requests, through: :books, source: :borrow_requests

  # --- NEW: Review Associations ---
  has_many :given_reviews, class_name: 'Review', foreign_key: 'reviewer_id', dependent: :destroy
  has_many :received_reviews, class_name: 'Review', foreign_key: 'reviewee_id', dependent: :destroy

  enum role: { general: 0, admin: 1 }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  
  # Calculate average 5-star rating from received reviews
  def average_rating
    return 0 if received_reviews.empty?
    received_reviews.average(:rating).round(1)
  end

  # Count successful returns (where the user was the borrower and it was completed)
  def successful_returns
    borrow_requests.where(status: 'returned').count
  end
end