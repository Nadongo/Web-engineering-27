require 'rails_helper'

RSpec.describe "User Authentication", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "allows a user to log in and access the catalog" do
    User.create!(name: "Jane Doe", email: "jane@example.com", password: "secretpassword")

    visit login_path
    
    fill_in "Email", with: "jane@example.com"
    fill_in "Password", with: "secretpassword"
    click_button "Log In"

    # FIX: Expect them to land on the Public Catalog instead of the Bookshelf
    expect(current_path).to eq(books_path)
    expect(page).to have_content("Public Catalog")
  end
end