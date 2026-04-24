require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'Validations' do
    it 'is valid with a name' do
      category = Category.new(name: 'African Fiction')
      expect(category).to be_valid
    end

    it 'is invalid without a name' do
      category = Category.new(name: nil)
      expect(category).not_to be_valid
    end
  end
end