class Category < ApplicationRecord
  has_many :books, dependent: :restrict_with_error

  validates :name, presence: true, length: { maximum: 255 }
end