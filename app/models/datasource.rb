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


  def update_score
    # Calculate score of datasources (temporary)
    return if self.size.nil?
    accessors = DataOwnership.where(datasource_id: self.id).where(type_of_ownership: ["accessor","buyer"]).count
    restricted = DataOwnership.where(datasource_id: self.id).where(type_of_ownership: ["restricted"]).count
    deleted = DataOwnership.where(datasource_id: self.id).where(type_of_ownership: ["deleted"]).count

    companies = accessors + restricted + deleted
    if companies == 0
      access_points = 75
    else
      access_points = 75 / companies
    end

    if self.size <= 1250
      score = (self.size * 0.02) + (75 - (accessors *  access_points))
    else
      score = 25 + (75 - (accessors *  access_points))
    end
    self.score = score
    self.save
  end

  def update_value
    # Calculate score of datasources (temporary)
    return if self.size.nil?
    puts "hihi"
    accessors = DataOwnership.where(datasource_id: self.id).where(type_of_ownership: ["accessor","buyer"]).count
    restricted = DataOwnership.where(datasource_id: self.id).where(type_of_ownership: ["restricted"]).count
    deleted = DataOwnership.where(datasource_id: self.id).where(type_of_ownership: ["deleted"]).count

    initial = (self.size / 400) * 860.63
    deletion_value = initial / (accessors + restricted + deleted)
    value = initial - (deleted * deletion_value)
    self.value = value
    self.save
    puts value
    return value
  end
end
