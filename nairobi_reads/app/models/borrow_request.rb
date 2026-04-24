class BorrowRequest < ApplicationRecord
  belongs_to :requester, class_name: 'User'
  belongs_to :book

  # A borrow request can have one review attached to it after it is returned
  has_one :review, dependent: :destroy

  # Updated validation to include the new 'returned' status
  validates :status, presence: true, inclusion: { in: %w[pending approved rejected returned] }
  
  # Set a default status when created
  after_initialize :set_default_status, if: :new_record?
  
  def set_default_status
    self.status ||= 'pending'
  end
end