class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  def home
  end

  def dashboard
    datasources = Datasource.all
    @google = datasources.find_by(name: "Google")
    @facebook = datasources.find_by(name: "Facebook")
    @twitter = datasources.find_by(name: "Twitter")
    @instagram = datasources.find_by(name: "Instagram")
    @spotify = datasources.find_by(name: "Spotify")
  end

   def loading
   end

  def tuto
    datasources = Datasource.all
    @google = datasources.find_by(name: "Google")
  end
end
