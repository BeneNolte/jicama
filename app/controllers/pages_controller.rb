require "open-uri"
require 'json'
require "google/apis/gmail_v1"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  def home
  end

  def dashboard
    @datasources = Datasource.all.where(user: current_user)
    @google = @datasources.find_by(name: "Google")
    @facebook = @datasources.find_by(name: "Facebook")
    @twitter = @datasources.find_by(name: "Twitter")
    @instagram = @datasources.find_by(name: "Instagram")
    @spotify = @datasources.find_by(name: "Spotify")
    @companies = Company.all

    # Calculate overall score of datasources
    score_arr = []
    if @datasources.where.not(score: nil).empty?
      @score = 0
    else

    @datasources.where.not(score: nil).each do |datasource|
      score_arr << datasource.score.to_i
    end
     @score = score_arr.sum / score_arr.size
      end

    # Calculate overall value of datasources
    value_arr = []
    @datasources.where.not(score: nil).each do |datasource|
      value_arr << datasource.value
    end
    @value = value_arr.sum.round(2)
  end

  def tuto
    datasources = current_user.datasources
    @datasource = datasources.find(params[:datasource_id])

    @service = Google::Apis::GmailV1::GmailService.new
    @service.client_options.application_name = ENV["APPLICATION_NAME"].freeze
    @url = create_google_url
  end


  def google
    @code = params[:code]
    client_id = Google::Auth::ClientId.from_file("app/controllers/google-credentials.json") # URI.open(ENV.fetch("CREDENTIALS_PATH")).read.freeze # ENV["CREDENTIALS_PATH"]
    token_store = Google::Auth::Stores::FileTokenStore.new file: "token.yaml".freeze # unsure we can put this here: put TOKEN_PATH
    authorizer = Google::Auth::UserAuthorizer.new client_id, Google::Apis::GmailV1::AUTH_GMAIL_READONLY, token_store # unsure we can put this here: put SCOPE
    @credentials = authorizer.get_and_store_credentials_from_code(user_id: current_user.email, code: @code, base_url: ENV["OOB_URI"].freeze)

    @service = Google::Apis::GmailV1::GmailService.new
    @service.client_options.application_name = ENV["APPLICATION_NAME"].freeze
    @service.authorization = authorize_google

    # Background job to retrieve emails
    company_title_arr = GoogleApiJob.perform_now(@service)

    @datasource = Datasource.find_by(name: "Google")
    # Store the emails in Jicama Database in order to display the titles to the user
    company_title_arr.each do |company_name|
      if Company.find_by(title: company_name.capitalize).nil?
        new_co = Company.new(title: company_name.capitalize, url: "www.test.de", description: "test test test", rating: 1)
        new_co.save!
        data_ownership = DataOwnership.new(company_id: new_co.id, datasource_id: @datasource.id, status: true, type_of_ownership: "accessor")
        data_ownership.save!
      end
    end

    # DataParseJob.perform_now(@datasource)
    redirect_to datasource_tuto_path(@datasource, code: @code, credentials: @credentials, anchor: "tuto-5")
  end

  private
  def create_google_url
    client_id = Google::Auth::ClientId.from_file("app/controllers/google-credentials.json") # URI.open(ENV.fetch("CREDENTIALS_PATH")).read.freeze # ENV["CREDENTIALS_PATH"]
    token_store = Google::Auth::Stores::FileTokenStore.new file: "token.yaml".freeze # unsure we can put this here: put TOKEN_PATH
    authorizer = Google::Auth::UserAuthorizer.new client_id, Google::Apis::GmailV1::AUTH_GMAIL_READONLY, token_store # unsure we can put this here: put SCOPE
    # user_id = "default"
    url = authorizer.get_authorization_url(base_url: ENV["OOB_URI"].freeze)
    # raise
    return url
  end

  def authorize_google
    client_id = Google::Auth::ClientId.from_file("app/controllers/google-credentials.json") # URI.open(ENV.fetch("CREDENTIALS_PATH")).read.freeze # ENV["CREDENTIALS_PATH"]
    token_store = Google::Auth::Stores::FileTokenStore.new file: "token.yaml".freeze # unsure we can put this here: put TOKEN_PATH
    authorizer = Google::Auth::UserAuthorizer.new client_id, Google::Apis::GmailV1::AUTH_GMAIL_READONLY, token_store # unsure we can put this here: put SCOPE
    # user_id = "default"
    user_id = current_user.email
    credentials = authorizer.get_credentials(user_id)
    if credentials.nil?
      url = authorizer.get_authorization_url(base_url: ENV["OOB_URI"].freeze)
      # puts "Open the following URL in the browser and enter the " \ "resulting code after authorization:\n"
      # p url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(user_id: user_id, code: code, base_url: ENV["OOB_URI"].freeze)
    end
    credentials
  end
end
