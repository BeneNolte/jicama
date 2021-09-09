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

    # @service = Google::Apis::GmailV1::GmailService.new
    # @service.client_options.application_name = ENV["APPLICATION_NAME"].freeze
    # @service.authorization = authorize_google #create_google_url
  end

  private
  # def create_google_url
  #   client_id = Google::Auth::ClientId.from_file("/Users/benediktnolte/code/BeneNolte/jicama/app/controllers/google-credentials.json") # URI.open(ENV.fetch("CREDENTIALS_PATH")).read.freeze # ENV["CREDENTIALS_PATH"]
  #   token_store = Google::Auth::Stores::FileTokenStore.new file: "token.yaml".freeze # unsure we can put this here: put TOKEN_PATH
  #   authorizer = Google::Auth::UserAuthorizer.new client_id, Google::Apis::GmailV1::AUTH_GMAIL_READONLY, token_store # unsure we can put this here: put SCOPE
  #   # user_id = "default"
  #   url = authorizer.get_authorization_url(base_url: ENV["OOB_URI"].freeze)
  #   # raise
  #   return url
  # end

  def authorize_google
    client_id = Google::Auth::ClientId.from_file("/Users/benediktnolte/code/BeneNolte/jicama/app/controllers/google-credentials.json") # URI.open(ENV.fetch("CREDENTIALS_PATH")).read.freeze # ENV["CREDENTIALS_PATH"]
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
      # raise
    end
    credentials
  end
end
