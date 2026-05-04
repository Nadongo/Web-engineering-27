require 'rails_helper'

RSpec.describe "Books", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:category) { Category.create!(name: "Fiction") }
  let!(:owner_user) { User.create!(name: "Owner", email: "owner@test.com", password: "password123", role: :general, preferred_meeting_spot: "Library") }
  let!(:other_user) { User.create!(name: "Other", email: "other@test.com", password: "password123", role: :general, preferred_meeting_spot: "Cafe") }
  let!(:admin_user) { User.create!(name: "Admin", email: "admin@test.com", password: "password123", role: :admin, preferred_meeting_spot: "Office") }
  
  let!(:target_book) { Book.create!(title: "The Great Novel", author: "Jane Doe", description: "A great read.", status: :available, owner: owner_user, category: category) }

  describe "Book CRUD and Access Restrictions" do
    it "allows a logged-in user to upload a book (Create)" do
      # Login
      visit login_path
      fill_in "Email", with: owner_user.email
      fill_in "Password", with: "password123"
      click_button "Log In"

      # Upload
      visit new_book_path
      fill_in "Title", with: "My New Book"
      fill_in "Author", with: "Awesome Writer"
      fill_in "Description", with: "This is a brand new book."
      select "Fiction", from: "Category"
      
      all('input[type="submit"]').last.click 

      expect(page).to have_content("My New Book")
    end

    it "allows anyone to view the catalog (Read)" do
      visit books_path
      expect(page).to have_content("The Great Novel")
    end

    it "prevents a user from editing someone else's book (Access Restriction)" do
      # Login as the wrong user
      visit login_path
      fill_in "Email", with: other_user.email
      fill_in "Password", with: "password123"
      click_button "Log In"

      # Try to edit the owner's book
      visit edit_book_path(target_book)
      
      # Should be bounced back
      expect(current_path).to eq(root_path).or eq(books_path)
    end

    it "allows an admin to delete any book (Access Restriction)" do
      # Login as Admin
      visit login_path
      fill_in "Email", with: admin_user.email
      fill_in "Password", with: "password123"
      click_button "Log In"

      # Delete the book directly
      page.driver.submit :delete, book_path(target_book), {}
      
      # Verify it's gone
      expect(Book.exists?(target_book.id)).to be_falsey
    end
  end
end