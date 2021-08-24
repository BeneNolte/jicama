class DatasourcesController < ApplicationController
  def show
    @datasource = Datasource.find(params[:id])
  end
end
