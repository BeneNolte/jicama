class AddTypeofownershipToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :type_of_ownership, :string
  end
end
