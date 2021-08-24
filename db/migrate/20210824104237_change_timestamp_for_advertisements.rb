class ChangeTimestampForAdvertisements < ActiveRecord::Migration[6.1]
  def change
    change_column :advertisements, :timestamp, :string
  end
end
