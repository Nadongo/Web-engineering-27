require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations and Negative Tests" do
    it "is valid with valid attributes" do
      user = User.new(name: "Test User", email: "test@nairobireads.com", password: "password123", preferred_meeting_spot: "Library")
      expect(user).to be_valid
    end

    it "is invalid without a name (Negative Test)" do
      user = User.new(email: "test@nairobireads.com", password: "password123")
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it "is invalid without an email (Negative Test)" do
      user = User.new(name: "Test User", password: "password123")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "is invalid with a duplicate email (Negative Test)" do
      User.create!(name: "Original", email: "duplicate@nairobireads.com", password: "password123", preferred_meeting_spot: "Library")
      duplicate_user = User.new(name: "Copycat", email: "duplicate@nairobireads.com", password: "password123", preferred_meeting_spot: "Cafe")
      
      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:email]).to include("has already been taken")
    end

    it "defines the role enum correctly (inclusion)" do
      expect(User.roles.keys).to contain_exactly("general", "admin")
    end
  end
end