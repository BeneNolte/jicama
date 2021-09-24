# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  def google_oauth2
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in @user
      google = current_user.datasources.find_by(name: "Google")
      if google.nil?
        google = Datasource.create!(user: current_user, name: "Google", downloaded: false, size: 0, score: 0, value: 0)
        file = URI.open(helpers.image_url("Google.png"))
        google.photo.attach(io: file, filename: 'Google.png', content_type: 'image/png')
        # cl_image_tag @datasource.photo.key, class:"datasource-logo ml-3"
        redirect_to datasource_tuto_path(google)
      else
        redirect_to datasource_path(google)
      end
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except('extra') # Removing extra as it can overflow some session stores
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

end
