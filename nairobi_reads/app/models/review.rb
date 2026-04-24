class Review < ApplicationRecord
  belongs_to :borrow_request
  belongs_to :reviewer, class_name: 'User'
  belongs_to :reviewee, class_name: 'User'

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, presence: true
end