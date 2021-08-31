class DataOwnershipsController < ApplicationController
  def index
    @datasource = Datasource.find(params[:datasource_id])
    @data_ownerships = policy_scope(DataOwnership)

    # Filtering Companies
    if params[:type_of_ownership].present? && params[:type_of_ownership] != "all"
      @data_ownerships = @data_ownerships.where(type_of_ownership: params[:type_of_ownership]).sort_by {|ownership| ownership.company.title }
    end

    # if params[:breed].present?
    #   @data_ownerships = @data_ownerships.where(breed: params[:breed])
    # end
  end

  # def edit
  #   @data_ownership = DataOwnership.find(params[:id])
  #   authorize @data_ownership
  # end

  def update
    @data_ownership = DataOwnership.find(params[:id])
    authorize @data_ownership
    @data_ownership.update(data_ownerships_params)
    if data_ownerships_params["type_of_ownership"] == "restricted"
      redirect_to datasource_data_ownerships_path(type_of_ownership: "accessor", dataprivacy: "restricted", company: @data_ownership.company.title)
    elsif data_ownerships_params["type_of_ownership"] == "deleted"
      redirect_to datasource_data_ownerships_path(type_of_ownership: "accessor", dataprivacy: "deleted", company: @data_ownership.company.title)
    elsif data_ownerships_params["type_of_ownership"] == "accessor"
      redirect_to datasource_data_ownerships_path(type_of_ownership: "accessor", dataprivacy: "allowed", company: @data_ownership.company.title)
    end
    @data_ownership.datasource.update_score
    @data_ownership.datasource.update_value

  end

  def filter
    @datasource = Datasource.find_by(name: "Google")
    current_user.auto_filter!
    @datasource.update_score
    @datasource.update_value
    skip_authorization
    redirect_to datasource_data_ownerships_path(@datasource, type_of_ownership: "accessor", dataprivacy: "filter")
  end

  private

  def data_ownerships_params
    params.require(:data_ownership).permit(:status, :type_of_ownership)
  end
end
