class ChangeStatusForAdvertisements < ActiveRecord::Migration[6.1]
  def change
    change_column :advertisements, :status, :boolean, using: 'status::boolean'
  end
end
