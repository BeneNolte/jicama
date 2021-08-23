class CreateInterestRecommendations < ActiveRecord::Migration[6.1]
  def change
    create_table :interest_recommendations do |t|
      t.string :category_type
      t.date :timestamp
      t.references :datasource, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
