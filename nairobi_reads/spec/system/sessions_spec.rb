require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  # Tell Capybara to use the fast, invisible browser
  before do
    driven_by(:rack_test)
  end

  let!(:user) { User.create!(name: "Test User", email: "test@nairobireads.com", password: "password123", preferred_meeting_spot: "Library") }

  describe "Login Functionality" do
    it "allows a user to log in securely and log out" do
      visit login_path
      fill_in "Email", with: user.email
      fill_in "Password", with: "password123"
      click_button "Log In" 

      # Changed this to look for the Profile link, which proves we are logged in!
      expect(page).to have_content("Profile")
      
      # Test Logout
      click_button "Log Out"
      expect(page).to have_content("Log In")
    end 

    it "prevents login with invalid credentials" do
      visit login_path
      fill_in "Email", with: user.email
      fill_in "Password", with: "wrongpassword"
      click_button "Log In"

      expect(page).not_to have_content("Log Out")
    end
  end
end