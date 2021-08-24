class ChangeStatusForDataownership < ActiveRecord::Migration[6.1]
  def change
    change_column :data_ownerships, :status, :boolean, using: 'status::boolean'
  end
end
