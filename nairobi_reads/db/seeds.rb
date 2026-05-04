# Clear existing data to prevent duplicates when running db:seed multiple times
Book.destroy_all
Category.destroy_all
User.destroy_all

puts "Creating Users..."
# We must create exactly 5 users to meet the passing requirement
admin = User.create!(
  name: "Admin User", 
  email: "admin@nairobireads.co.ke", 
  password: "password123", 
  role: :admin, 
  preferred_meeting_spot: "Nairobi National Library"
)

user1 = User.create!(
  name: "Wanjiku", 
  email: "wanjiku@example.com", 
  password: "password123", 
  role: :general, 
  preferred_meeting_spot: "Java House, Yaya Centre"
)

user2 = User.create!(
  name: "Kamau", 
  email: "kamau@example.com", 
  password: "password123", 
  role: :general, 
  preferred_meeting_spot: "K1 Klubhouse"
)

user3 = User.create!(
  name: "Akinyi", 
  email: "akinyi@example.com", 
  password: "password123", 
  role: :general, 
  preferred_meeting_spot: "Carnivore (let's grab nyamachoma!)"
)

user4 = User.create!(
  name: "Ochieng", 
  email: "ochieng@example.com", 
  password: "password123", 
  role: :general, 
  preferred_meeting_spot: "Prestige Plaza"
)

puts "Creating Categories..."
# 5 Categories to meet the passing requirement
cat1 = Category.create!(name: "Books & Reviews")
cat2 = Category.create!(name: "Reading Spots")
cat3 = Category.create!(name: "Book Clubs & Community")
cat4 = Category.create!(name: "Technology & Coding")
cat5 = Category.create!(name: "African Fiction")

puts "Creating Books..."
# 5 Books to meet the passing requirement
Book.create!(
  title: "Dust", 
  author: "Yvonne Adhiambo Owuor", 
  description: "A breathtaking novel exploring Kenya's history.", 
  status: :available, 
  owner: user1, 
  category: cat5
)

Book.create!(
  title: "Ruby on Rails Tutorial", 
  author: "Michael Hartl", 
  description: "Web development with Rails. Great condition.", 
  status: :borrowed, 
  owner: user2, 
  category: cat4
)

Book.create!(
  title: "Nairobi Heat", 
  author: "Mukoma Wa Ngugi", 
  description: "A fast-paced crime thriller set in Nairobi.", 
  status: :available, 
  owner: user3, 
  category: cat5
)

Book.create!(
  title: "Atomic Habits", 
  author: "James Clear", 
  description: "An easy & proven way to build good habits.", 
  status: :available, 
  owner: user4, 
  category: cat1
)

Book.create!(
  title: "The River and the Source", 
  author: "Margaret Ogola", 
  description: "A classic epic tracing four generations of Kenyan women.", 
  status: :borrowed, 
  owner: user1, 
  category: cat5
)

puts "Seed generation complete! 5 Users, 5 Categories, and 5 Books created."

puts "Creating Guest Accounts..."
# Guest General User
User.find_or_create_by!(email: 'guest@nairobireads.co.ke') do |user|
  user.name = "Guest User"
  user.password = "SecurePassword123!"
  user.password_confirmation = "SecurePassword123!"
  user.role = :general
  user.preferred_meeting_spot = "Any Public Library"
end

# Guest Admin User
User.find_or_create_by!(email: 'admin_guest@nairobireads.co.ke') do |user|
  user.name = "Admin Guest"
  user.password = "SecurePassword123!"
  user.password_confirmation = "SecurePassword123!"
  user.role = :admin
  user.preferred_meeting_spot = "Admin Office"
end

puts "Guest Accounts verified!"