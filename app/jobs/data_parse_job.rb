# require 'zip'

# class DataParseJob < ApplicationJob
#   queue_as :default

#   def perform(datasource)
#     # Do something later

#     # Download file
#     # zip = amazon.bucket('jicama').object("#{@datasource.file.path}").get(response_target: "#{@datasource.file.url}")
#     url = datasource.file.url
#     zip = URI.open(url)
#     # unzip file
#     Zip::File.open(zip) do |zipfile|
#       zipfile.each do |file|
#         # do something with file

#         p file.name == "__MACOSX/TakeoutBene/Location History/._Location History.json"
#       end
#     end
#     # Select relevant folders
#     # Stock relevant folder in database
#     puts "OK I'm done now"
#   end
# end
