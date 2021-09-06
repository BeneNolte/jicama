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
    if params[:datasource].nil?
      redirect_to datasource_tuto_path(@datasource, uploaded_file: "false", anchor: "tuto-4")
    else
      redirect_to datasource_tuto_path(@datasource, uploaded_file: "true")
      dataparse_job(@datasource)

      # issue : perform now before first redirection, and not possible to have to redirections and same action ..
    end
  end
  
  private
  
  def dataparse_job(datasource)
    datasource.update!(datasource_params)
    DataParseJob.perform_now(datasource)
    redirect_to datasource_path(datasource, uploaded_file: "done")
  end

  def datasource_params
    params.require(:datasource).permit(:file)
  end
end
