class AddEmailAndContactsToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :email, :string
    add_column :companies, :contact_times, :integer
  end
end
