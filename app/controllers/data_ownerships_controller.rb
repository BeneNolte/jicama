class DataOwnershipsController < ApplicationController
  def index
    @datasource = Datasource.find(params[:datasource_id])
    @data_ownerships = policy_scope(@datasource.data_ownerships)

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
      google(@data_ownership.company)
      redirect_to datasource_data_ownerships_path(type_of_ownership: "accessor", dataprivacy: "deleted", company: @data_ownership.company.title)
    elsif data_ownerships_params["type_of_ownership"] == "accessor"
      redirect_to datasource_data_ownerships_path(type_of_ownership: "accessor", dataprivacy: "allowed", company: @data_ownership.company.title)
    end
    @data_ownership.datasource.update_score
    @data_ownership.datasource.update_value

  end

  def filter
    @datasource = Datasource.where(user_id: current_user.id).find_by(name: "Google")
    deleted_previous = @datasource.data_ownerships.where(type_of_ownership: "deleted")
    previous_arr = []
    deleted_previous.each do |company|
      previous_arr << company
    end

    current_user.auto_filter!
    deleted_after = @datasource.data_ownerships.where(type_of_ownership: "deleted")
    after_arr = []
    deleted_after.each do |company|
      after_arr << company
    end

    deleted_new = after_arr - previous_arr

    deleted_new.each do |dataownership|
      google(dataownership.company)
    end

    @datasource.update_score
    @datasource.update_value
    skip_authorization
    redirect_to datasource_data_ownerships_path(@datasource, type_of_ownership: "accessor", dataprivacy: "filter")
  end

  private

  def data_ownerships_params
    params.require(:data_ownership).permit(:status, :type_of_ownership)
  end

  def authorize_google
    client_id = Google::Auth::ClientId.from_file("app/controllers/google-credentials.json") # URI.open(ENV.fetch("CREDENTIALS_PATH")).read.freeze # "app/controllers/google-credentials.json"
    token_store = Google::Auth::Stores::FileTokenStore.new file: "token.yaml".freeze # unsure we can put this here: put TOKEN_PATH
    authorizer = Google::Auth::UserAuthorizer.new client_id, Google::Apis::GmailV1::AUTH_SCOPE, token_store # unsure we can put this here: put SCOPE
    # user_id = "default"
    user_id = current_user.email
    credentials = authorizer.get_credentials(user_id)
    if credentials.nil?
      url = authorizer.get_authorization_url(base_url: ENV["OOB_URI"].freeze)
      # puts "Open the following URL in the browser and enter the " \ "resulting code after authorization:\n"
      # p url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(user_id: user_id, code: code, base_url: ENV["OOB_URI"].freeze)
    end
    credentials
  end

  def google(company)
    @service = Google::Apis::GmailV1::GmailService.new
    @service.client_options.application_name = ENV["APPLICATION_NAME"].freeze
    @service.authorization = authorize_google

    m = Mail.new(
        to: "ha.be.nolte@gmail.com",
        from: "#{current_user.email}",
        subject: "#{company.title} data erasure request - from #{current_user.first_name} #{current_user.last_name}",
        body:"Hello #{company.title} Team,

My name is #{current_user.first_name} #{current_user.last_name}, and I hereby request to erase all personal data that you hold about me.

Please send me an email confirmation of the complete and permanent erasure of the personal data once you have completed the erasure process.

My personal details are:

Name: #{current_user.first_name} #{current_user.last_name}
Email: #{current_user.email}

As evidence of my interaction with your company, I received in total #{company.contact_times} email(s) from you which indicates that you are holding personal data about me.

Thanks,
Benedikt Nolte
#{company.email}")
    msg = m.encoded
    # or m.to_s
    # this doesn't base64 encode. It just turns the Mail::Message object into an appropriate string.
    message_object = Google::Apis::GmailV1::Message.new(raw:m.to_s)
    @service.send_user_message("me", message_object)

    # @data_ownership = DataOwnership.find(params[:id])
    # authorize @data_ownership
    # redirect_to datasource_data_ownerships_path(type_of_ownership: "accessor", dataprivacy: "deleted", company: @data_ownership.company.title)
  end
end
