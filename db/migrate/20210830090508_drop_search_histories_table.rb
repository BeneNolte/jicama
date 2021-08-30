class DropSearchHistoriesTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :search_histories
  end
end
