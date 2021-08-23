class DataOwnership < ApplicationRecord
  belongs_to :company
  belongs_to :datasource
end
