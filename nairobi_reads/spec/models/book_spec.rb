require 'rails_helper'

RSpec.describe Book, type: :model do
  # Setup basic data needed for a book
  let(:user) { User.create!(name: "Author", email: "author@test.com", password: "password123", preferred_meeting_spot: "Library") }
  let(:category) { Category.create!(name: "Fiction") }

  describe "Validations and Negative Tests" do
    it "is valid with a title, author, and description" do
      book = Book.new(title: "Great Book", author: "John Doe", description: "A wonderful read.", owner: user, category: category)
      expect(book).to be_valid
    end

    it "is invalid without a description (Negative Test)" do
      book = Book.new(title: "No Description Book", author: "John Doe", owner: user, category: category)
      expect(book).not_to be_valid
      expect(book.errors[:description]).to include("can't be blank")
    end
  end

  describe "Scopes" do
    before do
      @available_book = Book.create!(title: "Avail Book", author: "A", description: "Desc", status: :available, owner: user, category: category)
      @borrowed_book = Book.create!(title: "Borr Book", author: "B", description: "Desc", status: :borrowed, owner: user, category: category)
    end

    it "correctly filters the 'available' scope" do
      expect(Book.available).to include(@available_book)
      expect(Book.available).not_to include(@borrowed_book)
    end

    it "correctly filters the 'borrowed' scope" do
      expect(Book.borrowed).to include(@borrowed_book)
      expect(Book.borrowed).not_to include(@available_book)
    end
  end
end