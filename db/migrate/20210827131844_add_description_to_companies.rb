class AddDescriptionToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :description, :text
  end
end
