require "open-uri"
require 'json'
require "google/apis/gmail_v1"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

class DatasourcesController < ApplicationController

  def show
    @datasource = Datasource.find(params[:id])
    authorize @datasource

    @locations = Location.where(datasource_id: @datasource.id)
    datasources = Datasource.all
    @google = datasources.find_by(name: "Google")

    # temporary condition
    # if @datasource.score.nil?
    #   @datasource.score = 0
    # end
    # if @datasource.size.nil?
    #   @datasource.size = 0
    # end
    @score = @datasource.score


    @chrome_search_words = ChromeSearchWord.where(datasource_id: @datasource.id).limit(50)
    @chrome_visited_links = ChromeVisitedLink.where(datasource_id: @datasource.id).limit(50)
    @youtube_video_channels = YoutubeVideoChannel.where(datasource_id: @datasource.id).limit(50)
    @youtube_video_titles = YoutubeVideoTitle.where(datasource_id: @datasource.id).limit(50)

    @viewed_advertisements = Advertisement.where(datasource_id: @datasource.id).sort_by(&:count).reverse!
    @clicked_advertisements = Advertisement.where(datasource_id: @datasource.id).where(status: false).sort_by(&:count).reverse!

    @locations = current_user.locations.limit(1000)

    if params[:start_date].present?
      @locations = @locations.where('timestamp >= ?', params[:start_date])
    end

    if params[:end_date].present?
      @locations = @locations.where('timestamp <= ?', params[:end_date])
    end

    @markers = @locations.map do |location|
      {
        lat: location.latitude,
        lng: location.longitude,
        info_window: render_to_string(partial: "info_window", locals: { location: location }),
        image_url: helpers.asset_url('location-marker.png')
      }
    end
  end

  def update
    @datasource = Datasource.find(params[:id])
    authorize @datasource
    # if params[:datasource][:file].nil?
    #   redirect_to datasource_tuto_path(@datasource, uploaded_file: "false", anchor: "tuto-4")
    # else
    # => the condition is handled in js

    @datasource.update!(datasource_params)

    @service = Google::Apis::GmailV1::GmailService.new
    @service.client_options.application_name = ENV["APPLICATION_NAME"].freeze
    @service.authorization = authorize_google

    DataParseJob.perform_now(@datasource)
    redirect_to dashboard_path(uploaded_file: "done")
  end

  private

  def datasource_params
    params.require(:datasource).permit(:file, :language)
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
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(user_id: user_id, code: code, base_url: ENV["OOB_URI"].freeze)
    end
    credentials
  end


end
