require "open-uri"

class DatasourcesController < ApplicationController
  def show
    @datasource = Datasource.find(params[:id])
    authorize @datasource
    @search_history = SearchHistory.where(datasource_id: @datasource.id)
  end
end
