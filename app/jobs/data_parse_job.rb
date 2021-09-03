class DataParseJob < ApplicationJob
  queue_as :default

  def perform(datasource)
    # Do something later

    # Download file
    # zip = amazon.bucket('jicama').object("#{@datasource.file.path}").get(response_target: "#{@datasource.file.url}")
    zip = datasource.file
    p zip
    # unzip file
    # Zip::File.open("my.zip") do |zipfile|
    #   zipfile.each do |file|
    #     # do something with file
    #   end
    # end
    # Select relevant folders
    # Stock relevant folder in database
    puts "OK I'm done now"
  end
end
