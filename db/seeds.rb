# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!(name: "Admin",
  email: "admin@example.com",
  password: "abc123",
  password_confirmation: "abc123",
  is_admin: true)

10.times do |n|
  name = Faker::Name.name
  description  = "abc-#{n+1}-cba"
  Category.create!(name: name,
    description: description)
end
