class Advertisement < ApplicationRecord
  belongs_to :company
  belongs_to :datasource
end
