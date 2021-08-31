class ModifyFieldsToAdvertisements < ActiveRecord::Migration[6.1]
  def change
    remove_column :advertisements, :company_id
    add_column :advertisements, :link, :string
    add_column :advertisements, :count, :integer
  end
end
