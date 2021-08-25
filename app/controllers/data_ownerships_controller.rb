class DataOwnershipsController < ApplicationController
  def index
    # @data_ownerships = DataOwnership.all
    @data_ownerships = policy_scope(DataOwnership)
    @datasource = Datasource.find(params[:datasource_id])
  end

  def edit
    @data_ownership = DataOwnership.find(params[:id])
  end

  def update
    @data_ownership = DataOwnership.find(params[:id])
    authorize @data_ownership
    @data_ownership.update(data_ownership_params)
    redirect_to datasource_data_ownerships_path, notice: "Your data settings have been updated"
  end

  private

  def data_ownerships_params
    params.require(:data_ownership).permit(:status, :type_of_ownership)
  end
end
