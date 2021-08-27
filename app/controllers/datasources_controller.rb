require "open-uri"

class DatasourcesController < ApplicationController
  def show
    @datasource = Datasource.find(params[:id])
    authorize @datasource

    @locations = Location.where(datasource_id: @datasource.id)
    datasources = Datasource.all
    @google = datasources.find_by(name: "Google")

    # temporary condition
    if @datasource.score.nil?
      @datasource.score = 0
    end
    if @datasource.size.nil?
      @datasource.size = 0
    end
    @score = @datasource.score

    @search_history = SearchHistory.where(datasource_id: @datasource.id)
    @youtube_history = YoutubeHistory.where(datasource_id: @datasource.id)
  end
end
