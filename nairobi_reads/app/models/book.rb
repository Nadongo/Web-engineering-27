class Book < ApplicationRecord
  # Tells Rails that 'owner' actually points to the User model
  belongs_to :owner, class_name: 'User'
  belongs_to :category

  # Book status: 0 for available, 1 for borrowed
  enum status: { available: 0, borrowed: 1 }

  validates :title, presence: true
  validates :author, presence: true
  validates :description, presence: true
end