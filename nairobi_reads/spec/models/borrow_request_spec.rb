require 'rails_helper'

RSpec.describe BorrowRequest, type: :model do
  # Setup the necessary data
  let(:owner) { User.create!(name: "Owner", email: "owner@test.com", password: "password123", preferred_meeting_spot: "Library") }
  let(:requester) { User.create!(name: "Requester", email: "req@test.com", password: "password123", preferred_meeting_spot: "Cafe") }
  let(:category) { Category.create!(name: "Fiction") }
  let(:book) { Book.create!(title: "Test Book", author: "Author", description: "Desc", owner: owner, category: category) }

  describe "Validations and Negative Tests" do
    it "is valid with a recognized status" do
      request = BorrowRequest.new(book: book, requester: requester, status: "pending")
      expect(request).to be_valid
    end

    it "is invalid with an unknown status (Negative Test)" do
      request = BorrowRequest.new(book: book, requester: requester, status: "lost_in_transit")
      expect(request).not_to be_valid
      expect(request.errors[:status]).to include("is not included in the list")
    end
  end
end