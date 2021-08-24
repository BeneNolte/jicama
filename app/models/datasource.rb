class Datasource < ApplicationRecord
  belongs_to :user
  has_many :advertisements, dependent: :destroy
  has_many :data_ownerships, dependent: :destroy
  has_many :interest_recommendations, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :youtube_channels, dependent: :destroy
end
