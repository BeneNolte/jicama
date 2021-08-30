class ChangeTimestampForLocations < ActiveRecord::Migration[6.1]
  def up
    remove_column :locations, :timestamp
    add_column :locations, :timestamp, :date
  end

  def down
    remove_column :locations, :timestamp
    add_column :locations, :timestamp, :string
  end
end
