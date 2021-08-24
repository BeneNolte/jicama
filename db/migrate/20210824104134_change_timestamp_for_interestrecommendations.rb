class ChangeTimestampForInterestrecommendations < ActiveRecord::Migration[6.1]
  def change
    change_column :interest_recommendations, :timestamp, :string
  end
end
