class AddRatingToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :rating, :integer
  end
end
