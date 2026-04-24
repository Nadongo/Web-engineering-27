require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    # Successful pattern
    it 'is valid with valid attributes' do
      user = User.new(name: 'Wanjiku', email: 'wanjiku@test.com', password: 'password', role: :general)
      expect(user).to be_valid
    end

    # Unsuccessful patterns
    it 'is invalid without a name' do
      user = User.new(email: 'wanjiku@test.com', password: 'password')
      expect(user).not_to be_valid
    end

    it 'is invalid without an email' do
      user = User.new(name: 'Wanjiku', password: 'password')
      expect(user).not_to be_valid
    end

    it 'is invalid with a duplicate email' do
      User.create!(name: 'Kamau', email: 'kamau@test.com', password: 'password')
      duplicate_user = User.new(name: 'Ochieng', email: 'kamau@test.com', password: 'password')
      expect(duplicate_user).not_to be_valid
    end
  end
end