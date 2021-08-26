class Datasource < ApplicationRecord
  belongs_to :user
  has_many :advertisements, dependent: :destroy
  has_many :data_ownerships, dependent: :destroy
  has_many :interest_recommendations, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_one_attached :photo
  has_many :search_histories, dependent: :destroy
  has_many :youtube_histories, dependent: :destroy
  has_many :chrome_search_words, dependent: :destroy
  has_many :chrome_visited_links, dependent: :destroy
  has_many :youtube_video_titles, dependent: :destroy
  has_many :youtube_video_channels, dependent: :destroy
end
