class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  def home
  end

  def dashboard

    @datasources = Datasource.all.where(user: current_user)
    @google = @datasources.find_by(name: "Google")
    @facebook = @datasources.find_by(name: "Facebook")
    @twitter = @datasources.find_by(name: "Twitter")
    @instagram = @datasources.find_by(name: "Instagram")
    @spotify = @datasources.find_by(name: "Spotify")

    # Calculate overall score of datasources
    score_arr = []
    @datasources.where.not(score: nil).each do |datasource|
      score_arr << datasource.score.to_i
    end
    @score = score_arr.sum / score_arr.size

    # Calculate overall value of datasources
    value_arr = []
    @datasources.where.not(score: nil).each do |datasource|
      value_arr << datasource.value
    end
    @value = value_arr.sum.round(2)
  end

   def loading
   end
end
