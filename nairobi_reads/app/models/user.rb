class User < ApplicationRecord
  # Encrypts the password_digest automatically
  has_secure_password 

  # Allows you to use current_user.admin? or current_user.general?
  enum role: { general: 0, admin: 1 }

  # A user can own many books. If a user is deleted, their books are removed.
  has_many :books, foreign_key: 'owner_id', dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }
end