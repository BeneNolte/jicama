class ChangeTimestampForLocation < ActiveRecord::Migration[6.1]
  def change
    change_column :locations, :timestamp, :string
  end
end
