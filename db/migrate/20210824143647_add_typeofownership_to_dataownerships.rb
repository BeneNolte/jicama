class AddTypeofownershipToDataownerships < ActiveRecord::Migration[6.1]
  def change
    add_column :data_ownerships, :type_of_ownership, :string
  end
end
