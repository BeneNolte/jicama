class AddScoreToDatasource < ActiveRecord::Migration[6.1]
  def change
    add_column :datasources, :score, :float
  end
end
