require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:general_user) { User.create!(name: "General User", email: "general@test.com", password: "password123", role: :general, preferred_meeting_spot: "Cafe") }
  let!(:admin_user) { User.create!(name: "Admin User", email: "admin@test.com", password: "password123", role: :admin, preferred_meeting_spot: "Office") }

  describe "User CRUD" do
    it "allows a new user to register (Create)" do
      visit new_user_path
      
      fill_in "user_name", with: "New Person"
      fill_in "user_email", with: "newperson@test.com"
      fill_in "user_password", with: "password123"
      fill_in "user_password_confirmation", with: "password123"
      fill_in "user_preferred_meeting_spot", with: "Nairobi CBD" 
      
      click_button "Create Account" 

      expect(page).to have_content("Welcome") 
    end

    it "allows a user to view their profile (Read)" do
      # Log in first
      visit login_path
      fill_in "Email", with: general_user.email
      fill_in "Password", with: "password123"
      click_button "Log In"

      visit user_path(general_user)
      expect(page).to have_content(general_user.name)
      expect(page).to have_content(general_user.preferred_meeting_spot)
    end
  end

  describe "Access Restrictions" do
    it "prevents a non-logged-in user from viewing a profile (require_login)" do
      visit user_path(general_user)
      # Should be bounced back to login page
      expect(current_path).to eq(login_path) 
    end

    it "prevents a non-admin from accessing the admin dashboard (require_admin)" do
      # Log in as a general user
      visit login_path
      fill_in "Email", with: general_user.email
      fill_in "Password", with: "password123"
      click_button "Log In"

      # Try to sneak into the admin dashboard
      visit admin_dashboard_path
      
      # Should be bounced back to the homepage/books page
      expect(current_path).to eq(root_path).or eq(books_path)
    end

    it "allows an admin to access the admin dashboard" do
      # Log in as an admin
      visit login_path
      fill_in "Email", with: admin_user.email
      fill_in "Password", with: "password123"
      click_button "Log In"

      # Go to admin dashboard
      visit admin_dashboard_path
      
      # Should successfully load
      expect(current_path).to eq(admin_dashboard_path)
      expect(page).to have_content("Admin Panel")
    end
  end
end