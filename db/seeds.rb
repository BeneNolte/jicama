# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#seed from Pierre's Google takeout - february 2018

puts "Cleaning db"
puts "🗑  Deleting all assets"

User.destroy_all
Datasource.destroy_all
Location.destroy_all

puts 'Creating a user'
user = User.new(email: "test@gmail.com", password: "123456", first_name: "Jicama", last_name: "Team")
user.save!
puts 'Finished user'

puts 'Creating Google'
google = Datasource.new(name: "Google", user: User.all.last)
google.save!
puts 'Finished Google'

puts 'Creating 5 locations...'
boutique_orange_republique = Location.new(latitude: 488669322, longitude: 23635334, timestamp: "1517499133098", datasource: Datasource.all.last, status: true)
boutique_orange_republique.save!

rue_saintonge = Location.new(latitude: 488627548, longitude: 23636928, timestamp: "1517503380552", datasource: Datasource.all.last, status: true)
rue_saintonge.save!

mannerheim_gallery = Location.new(latitude: 488671050, longitude: 23617439, timestamp: "1517499133098", datasource: Datasource.all.last, status: true)
mannerheim_gallery.save!

opticien_grandoptical = Location.new(latitude: 488669636, longitude: 23634875, timestamp: "1517499133098", datasource: Datasource.all.last, status: true)
opticien_grandoptical.save!

season_market = Location.new(latitude: 488628811, longitude: 23620257, timestamp: "1517503380552", datasource: Datasource.all.last, status: true)
season_market.save!

puts 'Finished 5 locations'

puts "You have created #{Location.all.length} locations"
