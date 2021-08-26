require "open-uri"

class DatasourcesController < ApplicationController
  def show
    @datasource = Datasource.find(params[:id])
    authorize @datasource

    @locations = Location.where(datasource_id: @datasource.id)
    datasources = Datasource.all
    @google = datasources.find_by(name: "Google")

    @score = @datasource.score

    @search_history = SearchHistory.where(datasource_id: @datasource.id)
  end
end
