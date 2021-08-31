class Datasource < ApplicationRecord
  belongs_to :user
  has_many :advertisements, dependent: :destroy
  has_many :data_ownerships, dependent: :destroy
  has_many :interest_recommendations, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_one_attached :photo
  has_many :chrome_search_words, dependent: :destroy
  has_many :chrome_visited_links, dependent: :destroy
  has_many :youtube_video_titles, dependent: :destroy
  has_many :youtube_video_channels, dependent: :destroy


  def update_score
    # Calculate score of datasources (temporary)
    return if self.size.nil?

    company_points = []
    self.data_ownerships.each do |data_ownership|
      company_points << data_ownership.company.rating
    end
    company_point = 75.0 / company_points.sum

    restricted_points = []
    self.data_ownerships.each do |data_ownership|
      restricted_points << data_ownership.company.rating if data_ownership.type_of_ownership == "restricted"
    end
    restricted_sum = restricted_points.sum

    access_points = []
    self.data_ownerships.each do |data_ownership|
      access_points << data_ownership.company.rating if data_ownership.type_of_ownership == "accessor"
    end
    access_sum = access_points.sum

    if self.size <= 25000
      score = (self.size * 0.001) + (75 - (access_sum * company_point  + restricted_sum * company_point * 0.25))
    else
      score = 25 + (75 - (access_sum * company_point  + restricted_sum * company_point * 0.25))
    end
    self.score = score
    self.save
  end

  def update_value
    # Calculate score of datasources (temporary)
    return if self.size.nil?
    deleted = DataOwnership.where(datasource_id: self.id).where(type_of_ownership: ["deleted"]).count

    company_points = []
    self.data_ownerships.each do |data_ownership|
      company_points << data_ownership.company.rating
    end
    company_points_sum = company_points.sum

    delete_points = []
    self.data_ownerships.each do |data_ownership|
      delete_points << data_ownership.company.rating if data_ownership.type_of_ownership == "deleted"
    end
    delete_sum = delete_points.sum

    initial = (self.size / 4300) * 860.63
    deletion_value = (initial * 0.2) / company_points_sum
    value = initial - (deletion_value * delete_sum)
    self.value = value
    self.save
    return value
  end
end
