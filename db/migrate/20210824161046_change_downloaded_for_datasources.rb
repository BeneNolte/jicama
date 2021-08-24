class ChangeDownloadedForDatasources < ActiveRecord::Migration[6.1]
  def change
    change_column :datasources, :downloaded, :boolean, using: 'downloaded::boolean'
  end
end
