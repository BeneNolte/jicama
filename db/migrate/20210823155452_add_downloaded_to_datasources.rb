class AddDownloadedToDatasources < ActiveRecord::Migration[6.1]
  def change
    add_column :datasources, :downloaded, :boolean
  end
end
