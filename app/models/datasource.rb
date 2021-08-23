class Datasource < ApplicationRecord
  belongs_to :user
  has_many :advertisements
  has_many :data_ownerships
  has_many :interest_recommendations, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :youtube_channels, dependent: :destroy
end
