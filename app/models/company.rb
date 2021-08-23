class Company < ApplicationRecord
  has_many :advertisements
  has_many :data_ownerships
  has_many :datasources, through: :data_ownerships
  has_many :datasources, through: :advertisements
end
