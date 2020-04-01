# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(name: "firstUser", email: "user1@test.com", password: "password", password_confirmation: "password")
User.create(name: "AdminUser2", email: "admin2@test.com", password: "password", password_confirmation: "password", admin: true)
User.create(name: "AdminUser3", email: "admin3@test.com", password: "password", password_confirmation: "password", admin: true)
User.create(name: "AdminUser4", email: "admin4@test.com", password: "password", password_confirmation: "password", admin: true)

Label.create(name: "勉強")
Labeling.create(label_id: 1, task_id: 16)