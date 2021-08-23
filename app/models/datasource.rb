class Datasource < ApplicationRecord
  belongs_to :user
  has_many :advertisements
  has_many :data_ownerships
  has_many :interest_recommendations
  has_many :locations
  has_many :youtube_channels
end
