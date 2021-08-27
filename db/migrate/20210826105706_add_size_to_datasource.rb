class AddSizeToDatasource < ActiveRecord::Migration[6.1]
  def change
    add_column :datasources, :size, :float
  end
end
