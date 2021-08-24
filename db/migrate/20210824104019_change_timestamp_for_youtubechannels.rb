class ChangeTimestampForYoutubechannels < ActiveRecord::Migration[6.1]
  def change
    change_column :youtube_channels, :timestamp, :string
  end
end
