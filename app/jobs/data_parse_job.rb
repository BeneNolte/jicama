require 'zip'

class DataParseJob < ApplicationJob
  queue_as :default

  def perform(datasource)
    # Do something later

    # Download file
    # zip = amazon.bucket('jicama').object("#{@datasource.file.path}").get(response_target: "#{@datasource.file.url}")
    url = datasource.file.url
    zip = URI.open(url)
    # unzip file

    # if datasource.language == "english"
     file_names = { profile: "Takeout/Profile/Profile.json" , browser_history: "Takeout/Chrome/BrowserHistory.json" , locations: "Takeout/My Activity/Maps/MyActivity.html", ads: "Takeout/My Activity/Ads/MyActivity.html", youtube_history: "Takeout/YouTube and YouTube Music/history/watch-history.html"}
    # elsif datasource.language == "french"
      # file_names = { profile: "Takeout/Profil/Profil.json" , browser_history: "Takeout/Chrome/BrowserHistory.json" , locations: "Takeout/Mon activité/Maps/MyActivity.html", ads: "Takeout/Mon activité/Ads/MyActivity.html", youtube_history: "Takeout/YouTube and YouTube Music/history/watch-history.html"}
    # end

    Zip::File.open(zip) do |zipfile|
      # Select relevant folders
      # files = zipfile.select do |file|
      #   file_names.values.include?(file.name)
      # end
      datasource.size = File.size(zip) / 1000.0
      datasource.save!

      files = {}
      # file_size = []
      zipfile.each do |file|
        files[:profile] = file            if file.name == file_names[:profile]
        files[:browser_history] = file    if file.name == file_names[:browser_history]
        files[:locations] = file          if file.name == file_names[:locations]
        files[:ads] = file                if file.name == file_names[:ads]
        files[:youtube_history] = file    if file.name == file_names[:youtube_history]
        # file_size << File.size(file)
      end

      # datasource.size = file_size.sum / 1000000.0
      # datasource.save!
      puts "-------------------------"
      p files
      puts "-------------------------"
      # p location = file.name == "TakeoutBene/Location/MyActivity_Location.html"
      # Stock relevant folder in database

      descending = -1
      # # # Profile
      # binding.pry
      profile_file = files[:profile]
      profileInfos = JSON.parse(profile_file.get_input_stream.read)
      gender = profileInfos["gender"]["type"].capitalize

      # # # Browser History
      browser_file = files[:browser_history]
      browserHistories = JSON.parse(browser_file.get_input_stream.read)
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
          datasource: datasource
        )
      end
      puts "Finished!"

#       # --> TOP SEARCH WORDS HISTORY OF ALL TIME
#       allSearchWords = []
#       browserHistories["Browser History"].each do |browserHistory|
#           allSearchWords << browserHistory["title"] unless browserHistory["title"].nil?
#       end
#       counts_all_search_words = Hash.new(0)
#       allSearchWords.join(" ").split(" ").each { |word| counts_all_search_words[word] += 1 if word != "Google" && word != "Search" && word != "Untitled" && word != "Request" && word.length > 3 }
#       rankedAllSearchWords = counts_all_search_words.sort_by { |key, value| value.to_i * descending}.to_a

#       puts "Creating Chrome Search Words from all time seeds"
#       rankedAllSearchWords.each do |element|
#         ChromeSearchWord.create(
#           word: element[0],
#           count: element[1],
#           time_range: "all",
#           datasource: datasource
#         )
#       end
#       puts "Finished!"

#       # 2. VISITED LINKS HISTORY
#       # --> TOP VISITED LINKS OF CURRENT MONTH
#       monthlyVisitedLinks = []
#       browserHistories["Browser History"].each do |browserHistory|
#         pattern = /(https?:\/\/www\.(\w+|\d+)\.\w{1,3}\/)(.+)/
#         if DateTime.strptime(browserHistory["time_usec"].to_s.first(10),'%s') > Date.today.beginning_of_month
#           monthlyVisitedLinks << browserHistory["url"].match(pattern)[1] unless browserHistory["url"].match(pattern).nil?
#         end
#       end
#       rankedMonthlyVisitedLinks = monthlyVisitedLinks.group_by(&:itself).transform_values { |value| value.count }.sort_by { |_, value| value * descending}.to_a

#       puts "Creating Chrome Visited Links monthly seeds"
#       rankedMonthlyVisitedLinks.each do |element|
#         ChromeVisitedLink.create(
#           link: element[0],
#           count: element[1],
#           time_range: "monthly",
#           datasource: datasource
#         )
#       end
#       puts "Finished!"

#       # --> TOP VISITED LINKS OF ALL TIME
#       allVisitedLinks = []
#       browserHistories["Browser History"].each do |browserHistory|
#         pattern = /(https?:\/\/www\.(\w+|\d+)\.\w{1,3}\/)(.+)/
#         allVisitedLinks << browserHistory["url"].match(pattern)[1] unless browserHistory["url"].match(pattern).nil?
#       end
#       rankedAllVisitedLinks = allVisitedLinks.group_by(&:itself).transform_values { |value| value.count }.sort_by { |_, value| value * descending}.to_a

#       puts "Creating Chrome Visited Links all time seeds"
#       rankedAllVisitedLinks.each do |element|
#         ChromeVisitedLink.create(
#           link: element[0],
#           count: element[1],
#           time_range: "all",
#           datasource: datasource
#         )
#       end
#       puts "Search Finished!"




#       # # # Location History
#       location_file = files[:locations]
#       # locationInfos = JSON.parse(profile_file.get_input_stream.read)
#       html_doc = Nokogiri::HTML(location_file.get_input_stream.read)
#       # html_doc = Nokogiri::HTML(html_file)
#       dateExtracts = html_doc.search("div.mdl-typography--body-1")
#       locations = []

#       dateExtracts.each do |dateExtract|
#         locationExtract = dateExtract.search("a")
#         if dateExtract.text.present? && locationExtract.present? && locationExtract.attribute('href')&.value.present?
#           pattern = /(<br>\w+ \d+, \d+, \d+:\d+:\d+ \w+ \w+)/
#           date = dateExtract.to_s.match(pattern)[1].gsub("<br>", "")
#           locationDate = Date.parse(date)
#           match_data = locationExtract.attribute("href").value.match(/(\d+\.\d+\,\d+\.\d+)/)
#           if match_data.nil? == false
#             latitude = match_data[1].split(",")[0]
#             longitude = match_data[1].split(",")[1]
#             locationName = I18n.transliterate(locationExtract.text.encode("iso-8859-1", invalid: :replace, undef: :replace).encode("utf-8", invalid: :replace, undef: :replace)).gsub('?', '')
#             locations << [latitude, longitude, locationName, locationDate]
#           end
#         end
#       end

#       # p ads_file = files[1]
#       # html_ads_doc = Nokogiri::HTML(ads_file.get_input_stream.read)

#       puts "Creating Bene's Maps location seeds"
#       locations.each do |location|
#         Location.create(
#           latitude: location[0],
#           longitude: location[1],
#           name: location[2],
#           timestamp: location[3],
#           datasource: datasource
#         )
#       end

#       puts "Finished!"

#       puts "Location Finished!"



#       # # # #--> NUMBER OF ADS & MOST CLICKED ADS

#       ads_file = files[:ads]
#       html_ads_doc = Nokogiri::HTML(ads_file.get_input_stream.read)

#       ads_extract = html_ads_doc.css("div.outer-cell")
#       ads_extract_count = ads_extract.count

#       ads_extract = html_ads_doc.css("div.content-cell")
#       ads_with_link_extract = html_ads_doc.css("div.content-cell a")
#       ads_extract_date = html_ads_doc.css("div.content-cell br")

#       ads_with_link = []
#       pattern_yt = /(https?:\/\/www\.(\w+|\d+)\.\w{1,3}\/)/
#       pattern_g = /url\?q=(\w*:\/\/[.\w]+\/)/

#       ads_extract.each do |ad|
#         if ad.css('a').attribute('href')&.value.present?
#           # line below equiv if !ad.attribute('href').nil? && ad.attribute('href').value.present?
#           attr = ad.css('a').attribute('href').value
#           if attr.match(pattern_g).nil?
#             if attr.match(pattern_yt)
#               ads_with_link << attr
#             end
#           else
#             ads_with_link << attr.match(pattern_g)[1]
#           end
#         else
#           ads_with_link << ""
#         end
#       end

#       ads_sorted = ads_with_link.select { |ads| ads != "" }
#       ads_with_link_ranking = ads_sorted.group_by(&:itself).transform_values { |value| value.count }.sort_by { |_, value| value * descending}.to_a

#       puts "Creating Bene's Ads seeds"

#       ads_with_link.each do |ads|
#         if ads == ""
#           Advertisement.create!(
#             status: false,
#             link: "",
#             count: 1,
#             timestamp: "all",
#             datasource: datasource
#           )
#         end
#       end

#       ads_with_link_ranking.each do |link, count|
#         Advertisement.create!(
#           status: true,
#           link: link,
#           count: count,
#           timestamp: "all",
#           datasource: datasource
#         )
#       end
#       puts "Ads Finished!"


#       # # # # YOUTUBE CHANNEL HISTORY
#       youtube_file = files[4]
#       youtube_file = files[:youtube_history]
#       html_doc = Nokogiri::HTML(youtube_file.get_input_stream.read)
#       # binding.pry
#       # --> TOP VIDEO TITLES OF ALL TIMES
#       videos = []
#       videoTitlesExtract = html_doc.css("div.mdl-grid div:nth-child(2) :first-child")
#       # trying to retrieve the date : p videoTitlesExtract.first.text
#       videoTitlesExtract.each do |element|
#         if element.text.length > 3 && element.attribute('href')&.value.present?
#         content = [I18n.transliterate(element.text.encode("iso-8859-1", invalid: :replace, undef: :replace).encode("utf-8", invalid: :replace, undef: :replace)).gsub('?', ''), element.attribute('href').value]
#         videos << content
#         end
#       end

#       rankedVideoTitles = videos.group_by(&:itself).transform_values { |value| value.count }.sort_by { |_, value| value * descending}.to_a

#       puts "Creating Youtube Video Titles all time seeds"
#       rankedVideoTitles.each do |element|
#         YoutubeVideoTitle.create(
#           title: element[0][0],
#           count: element[1],
#           url: element[0][1],
#           time_range: "all",
#           datasource: datasource
#         )
#       end
#       puts "Youtube Finished!"

#       # --> TOP CHANNELS FROM ALL TIMES
#       channels = []
#       videoChannelsExtract = html_doc.css("div.mdl-grid div:nth-child(2) a")
#       videoChannelsExtract.each do |element|
#         if element.text.length > 3 && element.attribute('href')&.value.present?
#           content = [I18n.transliterate(element.text.encode("iso-8859-1", invalid: :replace, undef: :replace).encode("utf-8", invalid: :replace, undef: :replace)).gsub('?', ''), element.attribute('href').value]
#           channels << content
#         end
#       end
#       rankedVideoChannels = channels.group_by(&:itself).transform_values { |value| value.count }.sort_by { |_, value| value * descending}.to_a

#       puts "Creating Youtube Video Channels all time seeds"
#       rankedVideoChannels.each do |element|
#         YoutubeVideoChannel.create(
#           title: element[0][0],
#           count: element[1],
#           url: element[0][1],
#           time_range: "all",
#           datasource: datasource
#         )
#       end
#       puts "Finished!"


    end
    puts "OK I'm done with all data charges"
  end
end