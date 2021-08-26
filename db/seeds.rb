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


# 1. BROWSER SEARCH WORDS HISTORY
filepath = './db/TakeoutBene/Chrome/BrowserHistory.json'
serialized_browserHistory = File.read(filepath)
browserHistories = JSON.parse(serialized_browserHistory)

# --> TOP SEARCH WORDS HISTORY OF CURRENT MONTH
monthlySearchWords = []
browserHistories["Browser History"].each do |browserHistory|
  if DateTime.strptime(browserHistory["time_usec"].to_s.first(10),'%s') > Date.today.beginning_of_month
    monthlySearchWords << browserHistory["title"] unless browserHistory["title"].nil?
  end
end
counts_monthly_search_words = Hash.new(0)
monthlySearchWords.join(" ").split(" ").each { |word| counts_monthly_search_words[word] += 1 if word != "Google" && word != "Search" && word != "Untitled" && word != "Request" && word.length > 3 }
rankedMonthlySearchWords = counts_monthly_search_words.sort_by { |key, value| value.to_i * descending}.to_a

# --> TOP SEARCH WORDS HISTORY OF ALL TIME
allSearchWords = []
browserHistories["Browser History"].each do |browserHistory|
    allSearchWords << browserHistory["title"] unless browserHistory["title"].nil?
end
counts_all_search_words = Hash.new(0)
allSearchWords.join(" ").split(" ").each { |word| counts_all_search_words[word] += 1 if word != "Google" && word != "Search" && word != "Untitled" && word != "Request" && word.length > 3 }
rankedAllSearchWords = counts_all_search_words.sort_by { |key, value| value.to_i * descending}.to_a

# 2. VISITED LINKS HISTORY
# --> TOP VISITED LINKS OF CURRENT MONTH
monthlyVisitedLinks = []
browserHistories["Browser History"].each do |browserHistory|
  pattern = /(https?:\/\/www\.(\w+|\d+)\.\w{1,3}\/)(.+)/
  if DateTime.strptime(browserHistory["time_usec"].to_s.first(10),'%s') > Date.today.beginning_of_month
    monthlyVisitedLinks << browserHistory["url"].match(pattern)[1] unless browserHistory["url"].match(pattern).nil?
  end
end
rankedMonthlyVisitedLinks = monthlyVisitedLinks.group_by(&:itself).transform_values { |value| value.count }.sort_by { |_, value| value * descending}.to_a

# --> TOP VISITED LINKS OF ALL TIME
allVisitedLinks = []
browserHistories["Browser History"].each do |browserHistory|
  pattern = /(https?:\/\/www\.(\w+|\d+)\.\w{1,3}\/)(.+)/
  allVisitedLinks << browserHistory["url"].match(pattern)[1] unless browserHistory["url"].match(pattern).nil?
end
rankedAllVisitedLinks = allVisitedLinks.group_by(&:itself).transform_values { |value| value.count }.sort_by { |_, value| value * descending}.to_a


# 3. YOUTUBE CHANNEL HISTORY
html_file = File.open('./db/TakeoutBene/YouTube and YouTube Music/history/watch-history.html')
html_doc = Nokogiri::HTML(html_file)

# --> TOP VIDEO TITLES OF ALL TIMES
videoTitles = []
videoTitlesExtract = html_doc.css("div.mdl-grid div:nth-child(2) :first-child")
# trying to retrieve the date : p videoTitlesExtract.first.text
videoTitlesExtract.each do |element|
  if element.text.length > 3
    videoTitles << element.text.gsub(/[^[:ascii:]]/, "").encode("iso-8859-1").force_encoding("utf-8")
  end
end
rankedVideoTitles = videoTitles.group_by(&:itself).transform_values { |value| value.count }.sort_by { |_, value| value * descending}.to_h

# --> TOP CHANNELS FROM ALL TIMES
videoChannels = []
videoChannelsExtract = html_doc.css("div.mdl-grid div:nth-child(2) a")
videoChannelsExtract.each do |element|
  if element.text.length > 3
    videoChannels << element.text.gsub(/[^[:ascii:]]/, "").encode("iso-8859-1").force_encoding("utf-8")
  end
end
rankedVideoChannels = videoChannels.group_by(&:itself).transform_values { |value| value.count }.sort_by { |_, value| value * descending}.to_h
# Links if we want them ? channelLinks = html_doc.css("div.mdl-grid div:nth-child(2) a").attribute('href').value

# CREATING THE SEEDS
puts "Cleaning db"
puts "🗑  Deleting all assets"

User.destroy_all
Datasource.destroy_all
Location.destroy_all
Company.destroy_all
SearchHistory.destroy_all

puts 'Creating a user'
user = User.new(email: "test@gmail.com", password: "123456", first_name: "Jicama", last_name: "Team")
user.save!
puts 'Finished user'

puts 'Creating 5 datasources'
instagram = Datasource.new(name: "Instagram", user: User.all.last, downloaded: false)
instagram.save!
instagram.update_score
instagram.update_value
spotify= Datasource.new(name: "Spotify", user: User.all.last, downloaded: false)
spotify.save!
spotify.update_score
spotify.update_value
twitter = Datasource.new(name: "Twitter", user: User.all.last, downloaded: false)
twitter.save!
twitter.update_score
twitter.update_value
facebook = Datasource.new(name: "Facebook", user: User.all.last, downloaded: false)
facebook.save!
facebook.update_score
facebook.update_value
google = Datasource.new(name: "Google", user: User.all.last, downloaded: true)
google.save!
google.update_score
google.update_value

file = URI.open('app/assets/images/Google.png')
google.photo.attach(io: file, filename: 'Google.png', content_type: 'image/png')
puts 'Finished 5 datasources'

puts 'Creating 5 locations...'
boutique_orange_republique = Location.new(latitude: 488669322, longitude: 23635334, timestamp: "1517499133098", datasource: google, status: true)
boutique_orange_republique.save!
rue_saintonge = Location.new(latitude: 488627548, longitude: 23636928, timestamp: "1517503380552", datasource: google, status: true)
rue_saintonge.save!
mannerheim_gallery = Location.new(latitude: 488671050, longitude: 23617439, timestamp: "1517499133098", datasource: google, status: true)
mannerheim_gallery.save!
opticien_grandoptical = Location.new(latitude: 488669636, longitude: 23634875, timestamp: "1517499133098", datasource: google, status: true)
opticien_grandoptical.save!
season_market = Location.new(latitude: 488628811, longitude: 23620257, timestamp: "1517503380552", datasource: google, status: true)
season_market.save!
puts 'Finished 5 locations'

puts 'Creating 5 companies'
axciom = Company.new(title: "axciom", url: "https://www.acxiom.com/")
axciom.save!
adform = Company.new(title: "adform", url: "https://site.adform.com/")
adform.save!
experian = Company.new(title: "experian", url: "https://www.experian.fr/")
experian.save!
levis = Company.new(title: "levis", url: "https://www.levi.com/")
levis.save!
apple = Company.new(title: "apple", url: "https://www.apple.com/")
apple.save!
puts 'Finished 5 companies'

puts 'Creating data ownerships'
own1 = DataOwnership.new(company: Company.order('RANDOM()').first, datasource: google, status: true, type_of_ownership: "buyer")
own1.save!
own2 = DataOwnership.new(company: Company.order('RANDOM()').first, datasource: google, status: true, type_of_ownership: "accessor")
own2.save!
own3 = DataOwnership.new(company: Company.order('RANDOM()').first, datasource: google, status: false, type_of_ownership: "restricted")
own3.save!
own4 = DataOwnership.new(company: Company.order('RANDOM()').first, datasource: google, status: false, type_of_ownership: "deleted")
own4.save!
puts 'Finished data ownerships'
google.update_score
google.update_value

puts "Creating Bene's search history"
beneSearchHistory = SearchHistory.create(
  top_search_word: rankedAllSearchWords,
  top_monthly_search_word: rankedMonthlySearchWords,
  top_visited_link: rankedAllVisitedLinks,
  top_monthly_visited_link: rankedMonthlyVisitedLinks,
  timestamp: Date.today,
  deleted: false,
  datasource: Datasource.find_by(name: "Google")
)
puts "Finsih creating Bene's search history"
