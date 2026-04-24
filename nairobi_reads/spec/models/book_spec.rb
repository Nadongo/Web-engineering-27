require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:user) { User.create!(name: 'Tester', email: 'test@test.com', password: 'password') }
  let(:category) { Category.create!(name: 'Tech') }

  describe 'Validations' do
    it 'is valid with all required attributes' do
      book = Book.new(title: 'Rails Guide', author: 'DHH', description: 'Great book', owner: user, category: category)
      expect(book).to be_valid
    end

    it 'is invalid without a title' do
      book = Book.new(author: 'DHH', description: 'Great book', owner: user, category: category)
      expect(book).not_to be_valid
    end

    it 'is invalid without an author' do
      book = Book.new(title: 'Rails Guide', description: 'Great book', owner: user, category: category)
      expect(book).not_to be_valid
    end
  end
end