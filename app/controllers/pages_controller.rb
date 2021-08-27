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
    @score = 0
    @datasources.where.not(score: nil).each do |datasource|
      score_arr << datasource.score.to_i
    end
    unless score_arr.size == 0
      @score = score_arr.sum / score_arr.size
    end

<<<<<<< HEAD
   def loading
   end

  def tuto
    datasources = Datasource.all
    @google = datasources.find_by(name: "Google")
=======
    # Calculate overall value of datasources
    value_arr = []
    @datasources.where.not(score: nil).each do |datasource|
      value_arr << datasource.value
    end
    @value = value_arr.sum.round(2)

    def loading
    end
>>>>>>> 2ed50b7663d168e10ff5ab0bd074e7fdb8a9928f
  end
end
