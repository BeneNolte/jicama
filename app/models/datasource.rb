class Datasource < ApplicationRecord
  belongs_to :user
  has_many :advertisements, dependent: :destroy
  has_many :data_ownerships, dependent: :destroy
  has_many :interest_recommendations, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :youtube_channels, dependent: :destroy
  has_one_attached :photo
  has_many :search_histories, dependent: :destroy


  def update_score
    # Calculate score of datasources (temporary)
    return if self.size.nil?
    accessors = DataOwnership.where(datasource_id: self.id).where(type_of_ownership: ["accessor","buyer"]).count
    restricted = DataOwnership.where(datasource_id: self.id).where(type_of_ownership: ["restricted"]).count
    deleted = DataOwnership.where(datasource_id: self.id).where(type_of_ownership: ["deleted"]).count

    access_points = 75 / (accessors + restricted + deleted)

    score = (self.size * 0.02) + (75 - (accessors *  access_points))
    self.score = score
    self.save
  end
end
