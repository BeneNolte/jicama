class DataOwnershipsController < ApplicationController
  def index
    @datasource = Datasource.find(params[:datasource_id])
    @data_ownerships = policy_scope(DataOwnership)

    # Filtering Companies
    if params[:type_of_ownership].present? && params[:type_of_ownership] != "all"
      @data_ownerships = @data_ownerships.where(type_of_ownership: params[:type_of_ownership]  || params[:XXX_small])
    else
      @data_ownerships = policy_scope(DataOwnership)
    end

    # if params[:breed].present?
    #   @data_ownerships = @data_ownerships.where(breed: params[:breed])
    # end
  end

  def edit
    @data_ownership = DataOwnership.find(params[:id])
    authorize @data_ownership
  end

  def update
    @data_ownership = DataOwnership.find(params[:id])
    authorize @data_ownership
    @data_ownership.update(data_ownerships_params)
    redirect_to datasource_data_ownerships_path, notice: "Your data settings have been updated"
  end

  private

  def data_ownerships_params
    params.require(:data_ownership).permit(:status, :type_of_ownership)
  end
end
