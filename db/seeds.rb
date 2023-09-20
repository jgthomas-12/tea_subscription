# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Customer.destroy_all
Tea.destroy_all
Subscription.destroy_all

10.times do
  FactoryBot.create(:customer)
end

20.times do
  FactoryBot.create(:tea)
end

30.times do
  FactoryBot.create(:subscription, customer: Customer.all.sample, tea: Tea.all.sample)
end