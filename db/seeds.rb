# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
categories = ["Social Events", "Corporate Events", "Cultural and Artistic Events", "Sports and Recreation Events", "Educational and Academic Events"]
categories.each do |category|
    EventCategory.create(event_category: category, status: true)
end