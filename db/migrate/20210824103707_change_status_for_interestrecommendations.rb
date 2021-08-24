class ChangeStatusForInterestrecommendations < ActiveRecord::Migration[6.1]
  def change
    change_column :interest_recommendations, :status, :boolean, using: 'status::boolean'
  end
end
