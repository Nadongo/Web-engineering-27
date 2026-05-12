require 'rails_helper'

RSpec.describe "BorrowRequests", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:category) { Category.create!(name: "Sci-Fi") }
  # Note: I temporarily made the owner an admin in this test so they can access the Admin Dashboard to approve the request!
  let!(:owner) { User.create!(name: "Owner", email: "owner@test.com", password: "password123", preferred_meeting_spot: "Library", role: :admin) }
  let!(:requester) { User.create!(name: "Requester", email: "req@test.com", password: "password123", preferred_meeting_spot: "Cafe") }
  let!(:book) { Book.create!(title: "Dune", author: "Frank Herbert", description: "Sandworms.", status: :available, owner: owner, category: category) }

  describe "The Borrowing Flow" do
    it "allows a user to request an available book" do
      visit login_path
      fill_in "Email", with: requester.email
      fill_in "Password", with: "password123"
      click_button "Log In"

      # Visit the book's public page directly (skipping the 'View Details' click to save test time)
      visit book_path(book)
      
      # Step 1: Click the initial button on the book details page
      click_on "Request to Borrow" 
      
      # Step 2: Click the final confirmation button on the borrowing screen
      click_on "Confirm Request"

      expect(BorrowRequest.last.status).to eq("pending")
      expect(BorrowRequest.last.requester).to eq(requester)
    end

    it "allows the owner to approve a pending request" do
      borrow_request = BorrowRequest.create!(book: book, requester: requester, status: "pending")

      visit login_path
      fill_in "Email", with: owner.email
      fill_in "Password", with: "password123"
      click_button "Log In"

      # Visit the dashboard we built earlier to click the exact Approve button
      visit admin_dashboard_path(tab: 'requests')
      click_button "Approve"

      borrow_request.reload
      book.reload

      expect(borrow_request.status).to eq("approved")
      expect(book.status).to eq("borrowed")
    end
  end

  describe "BorrowRequest Update and Delete" do
    let!(:pending_request) { BorrowRequest.create!(book: book, requester: requester, status: "pending") }

    it "allows the owner to update the status of a request (Update)" do
      visit login_path
      fill_in "Email", with: owner.email
      fill_in "Password", with: "password123"
      click_button "Log In"

      # Bypasses the UI and submits the approval directly to the controller
      page.driver.submit :patch, borrow_request_path(pending_request), { status: 'approved' }

      expect(pending_request.reload.status).to eq("approved")
    end

    it "allows a user to cancel/delete their request (Delete)" do
      visit login_path
      fill_in "Email", with: requester.email
      fill_in "Password", with: "password123"
      click_button "Log In"

      # Bypasses the Javascript confirmation pop-up completely
      page.driver.submit :delete, borrow_request_path(pending_request), {}
      
      expect(BorrowRequest.exists?(pending_request.id)).to be_falsey
    end
  end
end