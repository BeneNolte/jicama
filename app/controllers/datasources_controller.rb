class DatasourcesController < ApplicationController
  def show
    @datasource = Datasource.find(params[:id])
    authorize @datasource
    @locations = Location.where(datasource_id: @datasource.id)
  end
end
