# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#seed from Pierre's Google takeout - february 2018

require 'json'
require 'date'
require 'nokogiri'
descending = -1
# TIPS: to find the right relative path use ====> Dir.pwd

# PROFIL INFOS
filepath = './db/TakeoutBene/Profile/Profile.json'
serialized_profile = File.read(filepath)
profileInfos = JSON.parse(serialized_profile)
gender = profileInfos["gender"]["type"].capitalize

# BROWSER SEARCH HISTORY
filepath = './db/TakeoutBene/Chrome/BrowserHistory.json'
serialized_browserHistory = File.read(filepath)
browserHistories = JSON.parse(serialized_browserHistory)

# --> TOP SEARCH WORDS HISTORY OF CURRENT MONTH
monthlyTitles = []
browserHistories["Browser History"].each do |browserHistory|
  if DateTime.strptime(browserHistory["time_usec"].to_s.first(10),'%s') > Date.today.beginning_of_month
    monthlyTitles << browserHistory["title"] unless browserHistory["title"].nil?
  end
end
searchHistoryThisMonth = monthlyTitles.group_by(&:itself).transform_values { |value| value.count }.sort_by { |_, value| value * descending}.to_h
p searchHistoryThisMonth[-1]

# --> TOP SEARCH WORDS HISTORY
allTitles = []
browserHistories["Browser History"].each do |browserHistory|
    allTitles << browserHistory["title"] unless browserHistory["title"].nil?
end
searchHistory = allTitles.group_by(&:itself).transform_values { |value| value.count }.sort_by { |_, value| value * descending}.to_h
p searchHistory.last

# --> TOP VISITED LINKS OF CURRENT MONTH
links = []
browserHistories["Browser History"].each do |browserHistory|
  pattern = /(https?:\/\/www\.(\w+|\d+)\.\w{1,3}\/)(.+)/
  if DateTime.strptime(browserHistory["time_usec"].to_s.first(10),'%s') > Date.today.beginning_of_month
    links << browserHistory["url"].match(pattern)[1] unless browserHistory["url"].match(pattern).nil?
  end
end
visitedLinks = links.group_by(&:itself).transform_values { |value| value.count }.sort_by { |_, value| value * descending}.to_h
topVisitedLinks = visitedLinks.first(10)

# YOUTUBE CHANNEL HISTORY
html_file = File.open('./db/TakeoutBene/YouTube and YouTube Music/history/watch-history.html')
html_doc = Nokogiri::HTML(html_file)

# --> TOP TITLES FROM ALL TIMES
videoTitles = []
videoTitlesExtract = html_doc.css("div.mdl-grid div:nth-child(2) :first-child")
# trying to retrieve the date : p videoTitlesExtract.first.text
videoTitlesExtract.each do |element|
  if element.text.length > 3
    videoTitles << element.text
  end
end
videoTitles

rankedVideoTitles = videoTitles.group_by(&:itself).transform_values { |value| value.count }.sort_by { |_, value| value * descending}.to_h
rankedVideoTitles
# --> TOP CHANNELS FROM ALL TIMES
channelNames = []
channelNamesExtract = html_doc.css("div.mdl-grid div:nth-child(2) a")
channelNamesExtract.each do |element|
  if element.text.length > 3
    channelNames << element.text
  end
end
rankedChannelNames = channelNames.group_by(&:itself).transform_values { |value| value.count }.sort_by { |_, value| value * descending}.to_h
rankedChannelNames.first(10)
# Links if we want them ? channelLinks = html_doc.css("div.mdl-grid div:nth-child(2) a").attribute('href').value



# CREATING THE SEEDS
# puts "Cleaning db"
# puts "🗑  Deleting all assets"

# User.destroy_all
# Datasource.destroy_all
# Location.destroy_all
# Company.destroy_all
# SearchHistory.destroy_all

# puts 'Creating a user'
# user = User.new(email: "test@gmail.com", password: "123456", first_name: "Jicama", last_name: "Team")
# user.save!
# puts 'Finished user'

# puts 'Creating 5 datasources'
# instagram = Datasource.new(name: "Instagram", user: User.all.last, downloaded: false)
# instagram.save!
# spotify= Datasource.new(name: "Spotify", user: User.all.last, downloaded: false)
# spotify.save!
# twitter = Datasource.new(name: "Twitter", user: User.all.last, downloaded: false)
# twitter.save!
# facebook = Datasource.new(name: "Facebook", user: User.all.last, downloaded: false)
# facebook.save!
# google = Datasource.new(name: "Google", user: User.all.last, downloaded: true)
# google.save!
# puts 'Finished 5 datasources'

# puts 'Creating 5 locations...'
# boutique_orange_republique = Location.new(latitude: 488669322, longitude: 23635334, timestamp: "1517499133098", datasource: Datasource.all.last, status: true)
# boutique_orange_republique.save!
# rue_saintonge = Location.new(latitude: 488627548, longitude: 23636928, timestamp: "1517503380552", datasource: Datasource.all.last, status: true)
# rue_saintonge.save!
# mannerheim_gallery = Location.new(latitude: 488671050, longitude: 23617439, timestamp: "1517499133098", datasource: Datasource.all.last, status: true)
# mannerheim_gallery.save!
# opticien_grandoptical = Location.new(latitude: 488669636, longitude: 23634875, timestamp: "1517499133098", datasource: Datasource.all.last, status: true)
# opticien_grandoptical.save!
# season_market = Location.new(latitude: 488628811, longitude: 23620257, timestamp: "1517503380552", datasource: Datasource.all.last, status: true)
# season_market.save!
# puts 'Finished 5 locations'

# puts 'Creating 5 companies'
# axciom = Company.new(title: "axciom", url: "https://www.acxiom.com/")
# axciom.save!
# adform = Company.new(title: "adform", url: "https://site.adform.com/")
# adform.save!
# experian = Company.new(title: "experian", url: "https://www.experian.fr/")
# experian.save!
# levis = Company.new(title: "levis", url: "https://www.levi.com/")
# levis.save!
# apple = Company.new(title: "apple", url: "https://www.apple.com/")
# apple.save!
# puts 'Finished 5 companies'

# puts 'Creating data ownerships'
# own1 = DataOwnership.new(company: Company.order('RANDOM()').first, datasource: Datasource.all.last, status: true, type_of_ownership: "buyer")
# own1.save!
# own2 = DataOwnership.new(company: Company.order('RANDOM()').first, datasource: Datasource.all.last, status: true, type_of_ownership: "accessor")
# own2.save!
# own3 = DataOwnership.new(company: Company.order('RANDOM()').first, datasource: Datasource.all.last, status: false, type_of_ownership: "restricted")
# own3.save!
# own4 = DataOwnership.new(company: Company.order('RANDOM()').first, datasource: Datasource.all.last, status: false, type_of_ownership: "deleted")
# own4.save!
# puts 'Finished data ownerships'

# puts "Creating Bene's search history"
# beneSearchHistory = SearchHistory.create(top_search_words: topSearchWords, top_visited_links: topVisitedLinks, timestamp: Date.today, deleted: false, datasource: Datasource.find_by(name: "Google") )
# puts "Finsih creating Bene's search history"
