class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.float :latitude
      t.float :longitude
      t.date :timestamp
      t.references :datasource, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
