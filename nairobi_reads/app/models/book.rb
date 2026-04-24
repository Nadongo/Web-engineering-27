class Book < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  belongs_to :category
  
  has_many :borrow_requests, dependent: :destroy
  has_one_attached :cover_image

  enum status: { available: 0, borrowed: 1, reserved: 2 }

  validates :title, presence: true
  validates :author, presence: true
  validates :description, presence: true
  

  # Custom validation to enforce the 5-book limit per user
  validate :owner_book_limit, on: :create

  private

  def owner_book_limit
    if owner && owner.books.count >= 5
      errors.add(:base, "Your bookshelf is full! You can only list up to 5 books.")
    end
  end
end