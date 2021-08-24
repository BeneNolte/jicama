class RemoveTypeofownershipFromCompanies < ActiveRecord::Migration[6.1]
  def change
    remove_column :companies, :type_of_ownership, :string
  end
end
