class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :datasources
  has_many :data_ownerships, through: :datasources
  has_many :advertisements, through: :datasources
  has_many :youtube_channels, through: :datasources
  has_many :locations, through: :datasources
  has_many :interest_recommendations, through: :datasources
end
