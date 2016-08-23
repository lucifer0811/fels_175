# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = User.new(name: "Admin",
  email: "admin@example.com",
  password: "123456",
  password_confirmation: "123456",
  is_admin: true
)
user.skip_confirmation!
user.save!
10.times do |n|
  name = Faker::Name.name
  description  = "abc-#{n+1}-cba"
  avatar = Faker::Avatar.image("my-own-slug")
  Category.create!(name: name,
    description: description,
    avatar: avatar)
end

10.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@gmail.com"
  password = "123456"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password)
end

users = User.all
user  = users.first
following = users[2..10]
followers = users[3..10]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
