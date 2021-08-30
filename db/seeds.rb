
# CREATING THE SEEDS
puts "Cleaning db"
puts "🗑  Deleting all assets"
User.destroy_all
Datasource.destroy_all
Location.destroy_all
Company.destroy_all
ChromeSearchWord.destroy_all
ChromeVisitedLink.destroy_all
YoutubeVideoTitle.destroy_all
YoutubeVideoChannel.destroy_all


puts 'Creating a user'
user = User.new(email: "test@gmail.com", password: "123456", first_name: "Jicama", last_name: "Team")
user.save!
puts 'Finished!'

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
google = Datasource.new(name: "Google", user: User.all.last, downloaded: true, size: 400)
google.save!
google.update_score
google.update_value

file = URI.open('app/assets/images/Google.png')
google.photo.attach(io: file, filename: 'Google.png', content_type: 'image/png')
puts 'Finished!'

puts 'Creating 5 companies'
axciom = Company.new(title: "axciom", url: "https://www.acxiom.com/", description: "Acxiom (pronounced ax-ee-um) is a Conway, Arkansas-based database marketing company. The company collects, analyzes and sells customer and business information used for targeted advertising campaigns.")
axciom.save!
adform = Company.new(title: "adform", url: "https://site.adform.com/", description: "Adform is a global digital media advertising technology company. Its operations are headquartered in Europe, and its clients vary in size and industry.")
adform.save!
experian = Company.new(title: "experian", url: "https://www.experian.fr/", description: "Experian plc is an Anglo-Irish multinational consumer credit reporting company. Experian collects and aggregates information on over 1 billion people and businesses including 235 million individual U.S. consumers and more than 25 million U.S. businesses.")
experian.save!
levis = Company.new(title: "levis", url: "https://www.levi.com/", description: "Levi Strauss & Co. is an American clothing company known worldwide for its Levi's brand of denim jeans.")
levis.save!
apple = Company.new(title: "apple", url: "https://www.apple.com/", description: "Apple Inc. is an American multinational technology company that specializes in consumer electronics, computer software, and online services.")
apple.save!
puts 'Finished!'

puts 'Creating data ownerships'
own1 = DataOwnership.new(company: Company.order('RANDOM()').first, datasource: Datasource.all.last, status: true, type_of_ownership: "accessor")
own1.save!
own2 = DataOwnership.new(company: Company.order('RANDOM()').first, datasource: Datasource.all.last, status: true, type_of_ownership: "accessor")
own2.save!
own3 = DataOwnership.new(company: Company.order('RANDOM()').first, datasource: Datasource.all.last, status: false, type_of_ownership: "accessor")
own3.save!
own4 = DataOwnership.new(company: Company.order('RANDOM()').first, datasource: Datasource.all.last, status: false, type_of_ownership: "accessor")
own4.save!
google.update_score
google.update_value
puts 'Finished!'


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

puts "Creating Chrome Search Words monthly seeds"
rankedMonthlySearchWords.each do |element|
  ChromeSearchWord.create(
    word: element[0],
    count: element[1],
    time_range: "monthly",
    datasource: google
  )
end
puts "Finished!"

# --> TOP SEARCH WORDS HISTORY OF ALL TIME
allSearchWords = []
browserHistories["Browser History"].each do |browserHistory|
    allSearchWords << browserHistory["title"] unless browserHistory["title"].nil?
end
counts_all_search_words = Hash.new(0)
allSearchWords.join(" ").split(" ").each { |word| counts_all_search_words[word] += 1 if word != "Google" && word != "Search" && word != "Untitled" && word != "Request" && word.length > 3 }
rankedAllSearchWords = counts_all_search_words.sort_by { |key, value| value.to_i * descending}.to_a

puts "Creating Chrome Search Words from all time seeds"
rankedAllSearchWords.each do |element|
  ChromeSearchWord.create(
    word: element[0],
    count: element[1],
    time_range: "all",
    datasource: google
  )
end
puts "Finished!"

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

puts "Creating Chrome Visited Links monthly seeds"
rankedMonthlyVisitedLinks.each do |element|
  ChromeVisitedLink.create(
    link: element[0],
    count: element[1],
    time_range: "monthly",
    datasource: google
  )
end
puts "Finished!"

# --> TOP VISITED LINKS OF ALL TIME
allVisitedLinks = []
browserHistories["Browser History"].each do |browserHistory|
  pattern = /(https?:\/\/www\.(\w+|\d+)\.\w{1,3}\/)(.+)/
  allVisitedLinks << browserHistory["url"].match(pattern)[1] unless browserHistory["url"].match(pattern).nil?
end
rankedAllVisitedLinks = allVisitedLinks.group_by(&:itself).transform_values { |value| value.count }.sort_by { |_, value| value * descending}.to_a

puts "Creating Chrome Visited Links all time seeds"
rankedAllVisitedLinks.each do |element|
  ChromeVisitedLink.create(
    link: element[0],
    count: element[1],
    time_range: "all",
    datasource: google
  )
end
puts "Finished!"

# 3. YOUTUBE CHANNEL HISTORY
# youtube_file = './db/TakeoutBene/YouTube and YouTube Music/history/watch-history.html'
youtube_file = ENV.fetch("SECRET_YOUTUBE")
html_file = URI.open(youtube_file)
html_doc = Nokogiri::HTML(html_file)

# --> TOP VIDEO TITLES OF ALL TIMES
videos = []
videoTitlesExtract = html_doc.css("div.mdl-grid div:nth-child(2) :first-child")
# trying to retrieve the date : p videoTitlesExtract.first.text
videoTitlesExtract.each do |element|
  if element.text.length > 3 && element.attribute('href')&.value.present?
    videos << [element.text.gsub(/[^[:ascii:]]/, "").encode("iso-8859-1").force_encoding("utf-8"), element.attribute('href').value]
  end
end
rankedVideoTitles = videos.group_by(&:itself).transform_values { |value| value.count }.sort_by { |_, value| value * descending}.to_a

puts "Creating Youtube Video Titles all time seeds"
rankedVideoTitles.each do |element|
  YoutubeVideoTitle.create(
    title: element[0][0],
    count: element[1],
    url: element[0][1],
    time_range: "all",
    datasource: google
  )
end
puts "Finished!"

# --> TOP CHANNELS FROM ALL TIMES
channels = []
videoChannelsExtract = html_doc.css("div.mdl-grid div:nth-child(2) a")
videoChannelsExtract.each do |element|
  if element.text.length > 3 && element.attribute('href')&.value.present?
    channels << [element.text.gsub(/[^[:ascii:]]/, "").encode("iso-8859-1").force_encoding("utf-8"), element.attribute('href').value]
  end
end
rankedVideoChannels = channels.group_by(&:itself).transform_values { |value| value.count }.sort_by { |_, value| value * descending}.to_a

puts "Creating Youtube Video Channels all time seeds"
rankedVideoChannels.each do |element|
  YoutubeVideoChannel.create(
    title: element[0][0],
    count: element[1],
    url: element[0][1],
    time_range: "all",
    datasource: google
  )
end
puts "Finished!"

# Links if we want them ? channelLinks = html_doc.css("div.mdl-grid div:nth-child(2) a").attribute('href').value


# 4. LOCATIONS
html_file = File.open('./db/TakeoutBene/My Activity/Maps/MyActivity.html')
html_doc = Nokogiri::HTML(html_file)
dateExtracts = html_doc.search("div.mdl-typography--body-1")
locations = []

dateExtracts.each do |dateExtract|
  locationExtract = dateExtract.search("a")
  if dateExtract.text.present? && locationExtract.present? && locationExtract.attribute('href')&.value.present?
    pattern = /(<br>\w+ \d+, \d+, \d+:\d+:\d+ \w+ \w+)/
    date = dateExtract.to_s.match(pattern)[1].gsub("<br>", "")
    locationDate = Date.parse(date)
    match_data = locationExtract.attribute("href").value.match(/(\d+\.\d+\,\d+\.\d+)/)
    if match_data.nil? == false
      latitude = match_data[1].split(",")[0]
      longitude = match_data[1].split(",")[1]
      locationName = locationExtract.text.gsub(/[^[:ascii:]]/, "").encode("iso-8859-1").force_encoding("utf-8")
      locations << [latitude, longitude, locationName, locationDate]
    end
  end
end

p locations

puts "Creating Bene's Maps location seeds"
Location.create(
  latitude: locations[0][0],
  longitude: locations[0][1],
  name: locations[0][2],
  timestamp: locations[0][3]
)
puts "Finished!"
