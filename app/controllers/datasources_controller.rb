require "open-uri"

class DatasourcesController < ApplicationController
  def show
    @datasource = Datasource.find(params[:id])
    authorize @datasource
    @locations = Location.where(datasource_id: @datasource.id)
    datasources = Datasource.all
    @google = datasources.find_by(name: "Google")

    # Calculate score of datasources (temporary)
    @datasource_score = (@datasource.size * 0.02) + (66 - (5 * DataOwnership.all.where(datasource_id: @datasource.id).count))
    @datasource.score = @datasource_score
    @datasource.save
  end
end
