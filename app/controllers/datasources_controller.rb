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


    @chrome_search_words = ChromeSearchWord.where(datasource_id: @datasource.id)
    @chrome_visited_links = ChromeVisitedLink.where(datasource_id: @datasource.id)
    @youtube_video_channels = YoutubeVideoChannel.where(datasource_id: @datasource.id)
    @youtube_video_titles = YoutubeVideoTitle.where(datasource_id: @datasource.id)
  end
end
