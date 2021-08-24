class ChangeStatusForLocation < ActiveRecord::Migration[6.1]
  def change
    change_column :locations, :status, :boolean, using: 'status::boolean'
  end
end
