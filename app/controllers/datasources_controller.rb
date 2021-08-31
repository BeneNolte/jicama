require "open-uri"

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

    @clicked_advertisements = Advertisement.where(datasource_id: @datasource.id).sort_by(&:count).reverse!

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
        info_window: render_to_string(partial: "info_window", locals: { location: location })
      }
    end
  end
end
