# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'faker'

user = User.create({login: "simpl1g", email: "simpli4eg@gmail.com", password: "123456"})
Role.first.update_attributes(admin: true)
1.upto 30 do
  User.create({login: Faker::Name.name, email: Faker::Internet.email, password: "123456", two_step_auth: rand(2) })
end
