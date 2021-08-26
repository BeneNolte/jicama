class AddValueToDatasource < ActiveRecord::Migration[6.1]
  def change
    add_column :datasources, :value, :float
  end
end
